//
//  GameEngine.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Combine
import GameKit

typealias GameEngineAuthenticationBlock = (UIViewController?, Bool) -> Void
typealias GameEngineCompletionBlock = (Bool) -> Void

protocol GameEngineListener: AnyObject {
    func gameEngine(_ gameEngine: GameEngine, didReceive game: Game)
    func gameEngine(_ gameEngine: GameEngine, didStartGameWith player: PlayerDetails, totalPlayerCount: Int)
}

protocol GameEngine {
    func addListener(_ listener: GameEngineListener)

    var isAuthenticated: Bool { get }
    func authenticate(_ block: @escaping GameEngineAuthenticationBlock)

    func newMatchRequest(minPlayers: Int, maxPlayers: Int, inviteMessage: String) -> GKMatchRequest

    var localPlayerId: String { get }

    var gamePublisher: Published<Game>.Publisher { get }
    func update(gameData: GameData, completion: @escaping GameEngineCompletionBlock)
    func endTurn(gameData: GameData, completion: @escaping GameEngineCompletionBlock)
}

class GameKitGameEngine: NSObject, GameEngine {
    private let listenerContainer = GameEngineListenerContainer()
    private let coder = GameCoder()
    private let localPlayer = GKLocalPlayer.local

    private var currentMatch: GKTurnBasedMatch?

    @Published
    private var currentGamePublished: Game = .createFakeGame()
    var gamePublisher: Published<Game>.Publisher { $currentGamePublished }

    override init() {
        super.init()

        localPlayer.register(self)
    }

    func addListener(_ listener: GameEngineListener) {
        listenerContainer.addListener(listener)
    }

    var isAuthenticated: Bool {
        localPlayer.isAuthenticated
    }

    func authenticate(_ block: @escaping GameEngineAuthenticationBlock) {
        localPlayer.authenticateHandler = { [weak self] viewController, _ in
            block(viewController, self?.isAuthenticated ?? false)
        }
    }

    func newMatchRequest(minPlayers: Int, maxPlayers: Int, inviteMessage: String) -> GKMatchRequest {
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        request.inviteMessage = inviteMessage
        return request
    }

    var localPlayerId: String {
        localPlayer.gamePlayerID
    }

    func update(gameData: GameData, completion: @escaping GameEngineCompletionBlock) {
        guard let match = currentMatch, let data = coder.encode(gameData) else {
            completion(false)
            return
        }

        match.saveCurrentTurn(withMatch: data) { error in
            completion(error == nil)
        }
    }

    func endTurn(gameData: GameData, completion: @escaping GameEngineCompletionBlock) {
        guard let match = currentMatch, let data = coder.encode(gameData) else {
            completion(false)
            return
        }

        let nextParticipants = match.otherParticipants
        let playerDetails = nextParticipants.compactMap { $0.player }
            .map { $0.createPlayerDetails() }
        let nextPlayerId = nextParticipants.first?.player?.gamePlayerID
        let game = Game(gameData: gameData,
                        totalPlayerCount: match.nextParticipants.count,
                        playerDetails: playerDetails,
                        localPlayerId: localPlayer.gamePlayerID,
                        currentPlayerId: nextPlayerId)

        match.endTurn(withNextParticipants: nextParticipants,
                      turnTimeout: .turnTimeout,
                      match: data) { [weak self] error in
            self?.currentGamePublished = game
            completion(error == nil)
        }
    }
}

extension GameKitGameEngine: GKLocalPlayerListener {
    // MARK: - GKTurnBasedEventListener

    func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
        print("Function: \(#function), line: \(#line)")
    }

    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        print("Function: \(#function), line: \(#line)")
        currentMatch = match
        match.loadGame(coder: coder, localPlayer: localPlayer) { [weak self] matchState in
            guard let self = self else { return }

            switch matchState {
            case let .new(localPlayerDetails, totalPlayerCount):
                self.listenerContainer.gameEngine(self,
                                                  didStartGameWith: localPlayerDetails,
                                                  totalPlayerCount: totalPlayerCount)
            case let .inProgress(game):
                self.currentGamePublished = game
                self.listenerContainer.gameEngine(self, didReceive: game)
            }
        }
    }

    func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
        print("Function: \(#function), line: \(#line)")

        match.participants.filter { $0.status == .active }
            .forEach { $0.matchOutcome = $0.player == player ? .quit : .tied }

        match.endMatchInTurn(withMatch: match.matchData ?? Data())
    }

    func player(_ player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        print("Function: \(#function), line: \(#line)")
    }
}

private extension TimeInterval {
    static let turnTimeout = 60.0 * 60.0 * 24.0
}

private extension GKPlayer {
    func createPlayerDetails() -> PlayerDetails {
        PlayerDetails(id: gamePlayerID, name: displayName)
    }
}

private extension GKTurnBasedMatch {
    enum MatchState {
        case new(PlayerDetails, Int)
        case inProgress(Game)
    }

    func loadGame(coder: GameCoder, localPlayer: GKLocalPlayer, completion: @escaping (MatchState) -> Void) {
        loadMatchData { [weak self] data, _ in
            guard let self = self else { return }

            let totalPlayerCount = self.participants.count
            if let data = data, let gameData = coder.decode(data) {
                let playerDetails = self.participants.compactMap { $0.player }
                    .map { $0.createPlayerDetails() }
                let currentPlayerId = self.currentParticipant?.player?.gamePlayerID
                let game = Game(gameData: gameData,
                                totalPlayerCount: totalPlayerCount,
                                playerDetails: playerDetails,
                                localPlayerId: localPlayer.gamePlayerID,
                                currentPlayerId: currentPlayerId)
                completion(.inProgress(game))
            } else {
                let localPlayerDetails = localPlayer.createPlayerDetails()
                completion(.new(localPlayerDetails, totalPlayerCount))
            }
        }
    }

    var nextParticipants: [GKTurnBasedParticipant] {
        guard let currentParticipant = currentParticipant else {
            return otherParticipants
        }
        return otherParticipants + [currentParticipant]
    }

    var otherParticipants: [GKTurnBasedParticipant] {
        guard let currentParticipant = currentParticipant else {
            return participants
        }
        return participants.removing(currentParticipant)
    }
}
