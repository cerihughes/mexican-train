//
//  MockGameEngine.swift
//  Tests
//
//  Created by Ceri Hughes on 22/06/2020.
//

import Foundation

@testable import MexicanTrain

class MockGameEngine: GameEngine {
    func addListener(_ listener: GameEngineListener) {}

    var isAuthenticated = true
    func authenticate(_ block: @escaping GameEngineAuthenticationBlock) {
        block(nil, true)
    }

    var engineState: EngineState?

    @Published
    private var currentGamePublished = Game.createInitialGame()
    var gamePublisher: Published<Game>.Publisher { $currentGamePublished }

    func refresh() {}
    func update(game: Game, completion: @escaping GameEngineCompletionBlock) {}
    func endTurn(game: Game, completion: @escaping GameEngineCompletionBlock) {}

    func createState(totalPlayerCount: Int = 4,
                     playerDetails: [PlayerDetails] = [],
                     localPlayerId: String,
                     localPlayerIsCurrentPlayer: Bool = true) {
        engineState = EngineState(totalPlayerCount: totalPlayerCount,
                                  playerDetails: playerDetails,
                                  localPlayerId: localPlayerId,
                                  localPlayerIsCurrentPlayer: localPlayerIsCurrentPlayer)
    }

    func updateState(totalPlayerCount: Int? = nil,
                     playerDetails: [PlayerDetails]? = nil,
                     localPlayerId: String? = nil,
                     localPlayerIsCurrentPlayer: Bool? = nil) {
        engineState = engineState?.with(totalPlayerCount: totalPlayerCount,
                                        playerDetails: playerDetails,
                                        localPlayerId: localPlayerId,
                                        localPlayerIsCurrentPlayer: localPlayerIsCurrentPlayer)
    }
}

private extension EngineState {
    func with(totalPlayerCount: Int? = nil,
              playerDetails: [PlayerDetails]? = nil,
              localPlayerId: String? = nil,
              localPlayerIsCurrentPlayer: Bool? = nil) -> EngineState {
        EngineState(totalPlayerCount: totalPlayerCount ?? self.totalPlayerCount,
                    playerDetails: playerDetails ?? self.playerDetails,
                    localPlayerId: localPlayerId ?? self.localPlayerId,
                    localPlayerIsCurrentPlayer: localPlayerIsCurrentPlayer ?? self.localPlayerIsCurrentPlayer)
    }
}
