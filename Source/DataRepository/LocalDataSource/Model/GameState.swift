//
//  GameState.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import Foundation

struct GameState {
    let game: GameData
    let currentPlayerId: String
}

extension GameState {
    var currentPlayer: PlayerData? {
        game.player(id: currentPlayerId)
    }

    var otherPlayers: [PlayerData] {
        guard let currentPlayer = currentPlayer else {
            return game.players
        }

        return game.players.filter { $0.details.id != currentPlayer.details.id }
    }
}
