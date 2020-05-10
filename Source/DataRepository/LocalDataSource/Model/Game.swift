//
//  Game.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct Game {
    let stationValue: Domino.Value
    let currentPlayerId: Int
    let initialPlayerId: Int
    let mexicanTrain: [Domino]
    let players: [Player]
    let pool: [Domino]
}

extension Game {
    var currentPlayer: Player? {
        players.filter { $0.id == currentPlayerId }
            .first
    }

    func with(currentPlayerId: Int? = nil, mexicanTrain: [Domino]? = nil, players: [Player]? = nil, pool: [Domino]? = nil) -> Game {
        Game(stationValue: stationValue,
             currentPlayerId: currentPlayerId ?? self.currentPlayerId,
             initialPlayerId: initialPlayerId,
             mexicanTrain: mexicanTrain ?? self.mexicanTrain,
             players: players ?? self.players,
             pool: pool ?? self.pool)
    }

    func withIncrementedPlayer() -> Game? {
        guard let currentIndex = players.firstIndex(where: { $0.id == currentPlayerId }),
            let nextPlayer = players[safe: currentIndex + 1] ?? players.first else {
            return nil
        }

        return with(currentPlayerId: nextPlayer.id)
    }

    func with(updatedPlayer: Player, updatedPool: [Domino]) -> Game {
        let updatedPlayers = players.map { $0.id == updatedPlayer.id ? updatedPlayer : $0 }
        return with(players: updatedPlayers, pool: updatedPool)
    }
}
