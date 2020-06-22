//
//  FakeGameEngine.swift
//  Tests
//
//  Created by Home on 19/06/2020.
//

import Foundation

@testable import MexicanTrain

class FakeGameEngine {
    private var gameData: Game
    private let totalPlayerCount: Int
    private let localPlayerId: String

    private var currentPlayerIndex = 0

    init(gameData: Game, totalPlayerCount: Int = 4, localPlayerId: String) {
        self.gameData = gameData
        self.totalPlayerCount = totalPlayerCount
        self.localPlayerId = localPlayerId
    }

    func createInitialState() -> GameTurn {
        let playerDetails = generatedPlayerDetails
        return GameTurn(gameData: gameData,
                    totalPlayerCount: totalPlayerCount,
                    playerDetails: playerDetails,
                    localPlayerId: localPlayerId,
                    isCurrentPlayer: isCurrentPlayer)
    }

    func incrementedState(gameData: Game) -> GameTurn {
        currentPlayerIndex += 1
        currentPlayerIndex %= totalPlayerCount

        return GameTurn(gameData: gameData,
                    totalPlayerCount: totalPlayerCount,
                    playerDetails: generatedPlayerDetails,
                    localPlayerId: localPlayerId,
                    isCurrentPlayer: isCurrentPlayer)
    }

    private var isCurrentPlayer: Bool {
        currentPlayerIndex == 0
    }

    private var generatedPlayerDetails: [PlayerDetails] {
        gameData.players.map { $0.id }
            .map { PlayerDetails(id: $0, name: "Player_\($0)") }
    }
}
