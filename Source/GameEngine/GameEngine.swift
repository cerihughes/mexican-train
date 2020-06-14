//
//  GameEngine.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import GameKit

typealias GameEngineAuthenticationBlock = (UIViewController?, Bool) -> Void
typealias GameEngineCompletionBlock = (Bool) -> Void

protocol GameEngineListener: AnyObject {
    func gameEngine(_ gameEngine: GameEngine, didReceive game: GameData)
    func gameEngine(_ gameEngine: GameEngine, didStartGameWith player: PlayerDetails, totalPlayerCount: Int)
}

protocol GameEngine {
    func addListener(_ listener: GameEngineListener)

    var isAuthenticated: Bool { get }
    func authenticate(_ block: @escaping GameEngineAuthenticationBlock)

    func newMatchRequest(minPlayers: Int, maxPlayers: Int, inviteMessage: String) -> GKMatchRequest

    var localPlayerId: String { get }
    func update(gameData: GameData, completion: @escaping GameEngineCompletionBlock)
}

class GameKitGameEngine: NSObject, GameEngine {
    private let listenerContainer = GameEngineListenerContainer()
    private let coder = GameCoder()
    private let localPlayer = GKLocalPlayer.local

    private var currentMatch: GKTurnBasedMatch?

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

        match.endTurn(withNextParticipants: [],
                      turnTimeout: .turnTimeout,
                      match: data) { error in
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
        match.loadMatchData { [weak self] data, _ in
            guard let self = self else {
                return
            }

            if let data = data, let game = self.coder.decode(data) {
                self.listenerContainer.gameEngine(self, didReceive: game)
            } else {
                self.listenerContainer.gameEngine(self,
                                                  didStartGameWith: self.localPlayer.createPlayerDetails(),
                                                  totalPlayerCount: match.participants.count)
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
