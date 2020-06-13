//
//  GameState.swift
//  MexicanTrain
//
//  Created by Home on 13/06/2020.
//

import Foundation

struct GameState {
    let game: Game
    let currentPlayerId: String
}

extension GameState {
    var currentPlayer: Player? {
        game.player(id: currentPlayerId)
    }

    var otherPlayers: [Player] {
        guard let currentPlayer = currentPlayer else {
            return game.players
        }

        return game.players.filter { $0.details.id != currentPlayer.details.id }
    }
}
