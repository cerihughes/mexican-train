//
//  Game.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import Foundation

struct Game {
    let gameData: GameData
    let currentPlayerId: String
}

extension Game {
    var currentPlayer: PlayerData? {
        gameData.player(id: currentPlayerId)
    }

    var otherPlayers: [PlayerData] {
        guard let currentPlayer = currentPlayer else {
            return gameData.players
        }

        return gameData.players.filter { $0.details.id != currentPlayer.details.id }
    }
}
