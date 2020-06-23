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

protocol GameEngine: AnyObject {
    func addListener(_ listener: GameEngineListener)

    var isAuthenticated: Bool { get }
    func authenticate(_ block: @escaping GameEngineAuthenticationBlock)

    var engineState: EngineState? { get }
    var gamePublisher: Published<Game>.Publisher { get }
    func refresh()
    func update(game: Game, completion: @escaping GameEngineCompletionBlock)
    func endTurn(game: Game, completion: @escaping GameEngineCompletionBlock)
}

extension GameEngine {
    var localPlayerPublisher: AnyPublisher<Player, Never> {
        gamePublisher.compactMap { [weak self] in $0.player(id: self?.engineState?.localPlayerId ?? "") }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

class GameKitGameEngine: NSObject, GameEngine {
    private let listenerContainer = GameEngineListenerContainer()
    private let coder = GameCoder()
    private let localPlayer = GKLocalPlayer.local

    private var currentMatch: GKTurnBasedMatch?

    @Published
    private var currentGamePublished = Game.createInitialGame()
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

    var engineState: EngineState? {
        currentMatch?.createEngineState(localPlayer: localPlayer)
    }

    func refresh() {
        guard let currentMatch = currentMatch else { return }
        GKTurnBasedMatch.load(withID: currentMatch.matchID) { [weak self] match, _ in
            guard let self = self, let match = match else { return }

            self.currentMatch = match

            match.loadGame(coder: self.coder, localPlayer: self.localPlayer) { [weak self] matchState in
                guard let self = self, case let .inProgress(game) = matchState else { return }
                self.currentGamePublished = game
            }
        }
    }

    func update(game: Game, completion: @escaping GameEngineCompletionBlock) {
        guard let currentMatch = currentMatch, let data = coder.encode(game) else {
            completion(false)
            return
        }

        currentMatch.saveCurrentTurn(withMatch: data) { [weak self] error in
            guard let self = self, error == nil else {
                completion(false)
                return
            }
            self.currentGamePublished = game
            completion(true)
        }
    }

    func endTurn(game: Game, completion: @escaping GameEngineCompletionBlock) {
        // Wipe all player turn progress when a turn ends...
        let players = game.players.map { $0.with(currentTurn: []) }
        let updatedGame = game.with(players: players)

        guard let currentMatch = currentMatch, let data = coder.encode(updatedGame) else {
            completion(false)
            return
        }

        currentMatch.endTurn(withNextParticipants: currentMatch.nextParticipants,
                             turnTimeout: GKTurnTimeoutNone,
                             match: data) { [weak self] error in
            guard let self = self, error == nil else {
                completion(false)
                return
            }
            self.currentGamePublished = game
            completion(true)
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
            case let .inProgress(state):
                self.currentGamePublished = state
                self.listenerContainer.gameEngine(self, didReceive: state)
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
            if let data = data, let game = coder.decode(data) {
                completion(.inProgress(game))
            } else {
                let localPlayerDetails = localPlayer.createPlayerDetails()
                completion(.new(localPlayerDetails, totalPlayerCount))
            }
        }
    }

    func createEngineState(localPlayer: GKLocalPlayer) -> EngineState {
        let playerDetails = participants.compactMap { $0.player }
            .map { $0.createPlayerDetails() }
        let localPlayerIsCurrentPlayer = currentParticipant?.player == localPlayer
        return EngineState(totalPlayerCount: participants.count,
                           playerDetails: playerDetails,
                           localPlayerId: localPlayer.gamePlayerID,
                           localPlayerIsCurrentPlayer: localPlayerIsCurrentPlayer)
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

extension Game {
    static func createInitialGame() -> Game {
        Game(stationValue: .twelve,
             mexicanTrain: Train(isPlayable: true, dominoes: []),
             players: [],
             pool: [],
             openGates: [])
    }
}
