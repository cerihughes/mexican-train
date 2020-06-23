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
}

protocol GameEngine {
    func addListener(_ listener: GameEngineListener)

    var isAuthenticated: Bool { get }
    func authenticate(_ block: @escaping GameEngineAuthenticationBlock)

    func newMatchRequest(minPlayers: Int, maxPlayers: Int, inviteMessage: String) -> GKMatchRequest

    var localPlayerId: String { get }

    var gamePublisher: Published<Game>.Publisher { get }
    func refresh()
    func update(gameData: GameData, completion: @escaping GameEngineCompletionBlock)
    func endTurn(gameData: GameData, completion: @escaping GameEngineCompletionBlock)
}

class GameKitGameEngine: NSObject, GameEngine {
    private let listenerContainer = GameEngineListenerContainer()
    private let coder = GameCoder()
    private let localPlayer = GKLocalPlayer.local

    private var currentMatch: GKTurnBasedMatch?

    @Published
    private var currentGamePublished = Game()
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

    func refresh() {
        guard let currentMatch = currentMatch else { return }
        GKTurnBasedMatch.load(withID: currentMatch.matchID) { [weak self] match, _ in
            guard let self = self, let match = match else { return }

            self.currentMatch = match

            match.loadGame(coder: self.coder, localPlayer: self.localPlayer) { [weak self] game in
                self?.currentGamePublished = game
            }
        }
    }

    func update(gameData: GameData, completion: @escaping GameEngineCompletionBlock) {
        guard let currentMatch = currentMatch, let data = coder.encode(gameData) else {
            completion(false)
            return
        }

        currentMatch.saveCurrentTurn(withMatch: data) { [weak self] error in
            guard let self = self else { return }
            self.currentGamePublished = currentMatch.createGame(gameData: gameData, localPlayer: self.localPlayer)
            completion(error == nil)
        }
    }

    func endTurn(gameData: GameData, completion: @escaping GameEngineCompletionBlock) {
        // Wipe all player turn progress when a turn ends...
        let players = gameData.players.map { $0.with(currentTurn: []) }
        let updatedGameData = gameData.with(players: players)

        guard let currentMatch = currentMatch, let data = coder.encode(updatedGameData) else {
            completion(false)
            return
        }

        currentMatch.endTurn(withNextParticipants: currentMatch.nextParticipants,
                             turnTimeout: GKTurnTimeoutNone,
                             match: data) { [weak self] error in
            guard let self = self else { return }
            self.currentGamePublished = currentMatch.createGame(gameData: gameData, localPlayer: self.localPlayer)
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
        match.loadGame(coder: coder, localPlayer: localPlayer) { [weak self] game in
            guard let self = self else { return }
            self.currentGamePublished = game
            self.listenerContainer.gameEngine(self, didReceive: game)
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

private extension GKPlayer {
    func createPlayerDetails() -> PlayerDetails {
        PlayerDetails(id: gamePlayerID, name: displayName)
    }
}

private extension GKTurnBasedMatch {
    func loadGame(coder: GameCoder, localPlayer: GKLocalPlayer, completion: @escaping (Game) -> Void) {
        loadMatchData { [weak self] data, _ in
            guard let self = self else { return }

            let game: Game
            if let data = data, let gameData = coder.decode(data) {
                game = self.createGame(gameData: gameData, localPlayer: localPlayer)
            } else {
                game = self.createGame(gameData: GameData(), localPlayer: localPlayer)
            }
            completion(game)
        }
    }

    func createGame(gameData: GameData, localPlayer: GKLocalPlayer) -> Game {
        let playerDetails = participants.compactMap { $0.player }
            .map { $0.createPlayerDetails() }
        let isCurrentPlayer = currentParticipant?.player == localPlayer
        return Game(gameData: gameData,
                    totalPlayerCount: participants.count,
                    playerDetails: playerDetails,
                    localPlayerId: localPlayer.gamePlayerID,
                    isCurrentPlayer: isCurrentPlayer)
    }

    var nextParticipants: [GKTurnBasedParticipant] {
        guard let currentParticipant = currentParticipant,
            let index = participants.firstIndex(of: currentParticipant),
            let nextParticipant = participants[safe: index + 1] ?? participants.first else {
            return otherParticipants
        }
        return [nextParticipant]
    }

    var otherParticipants: [GKTurnBasedParticipant] {
        guard let currentParticipant = currentParticipant else {
            return participants
        }
        return participants.removing(currentParticipant)
    }
}
