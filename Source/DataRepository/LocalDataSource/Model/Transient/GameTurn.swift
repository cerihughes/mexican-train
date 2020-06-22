//
//  GameTurn.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import Foundation

struct GameTurn {
    let totalPlayerCount: Int
    let playerDetails: [PlayerDetails]
    let localPlayerId: String
    let isCurrentPlayer: Bool
}

extension GameTurn {
    var localPlayerIndex: Int? {
        playerDetails.firstIndex(where: { $0.id == localPlayerId })
    }
}

extension Player {
    func hasMatchingDominoFor(value: DominoValue) -> Bool {
        return !dominoes
            .filter { $0.has(value: value) }
            .isEmpty
    }
}

extension GameState {
    static func createFakeGame() -> GameState {
        let gameTurn = GameTurn(totalPlayerCount: 0, playerDetails: [], localPlayerId: "", isCurrentPlayer: false)
        let game = Game(stationValue: .twelve, mexicanTrain: Train(isPlayable: true, dominoes: []), players: [], pool: [], openGates: [])
        return GameState(turn: gameTurn, game: game)
    }
}
