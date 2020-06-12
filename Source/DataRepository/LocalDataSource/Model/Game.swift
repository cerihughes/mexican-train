//
//  Game.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct Game: Equatable, Codable {
    let stationValue: DominoValue
    let currentPlayerId: Int
    let initialPlayerId: Int
    let mexicanTrain: Train
    let players: [Player]
    let pool: [UnplayedDomino]
}

extension Game {
    var currentPlayer: Player? {
        player(id: currentPlayerId)
    }

    var otherPlayers: [Player] {
        guard let currentPlayer = currentPlayer else {
            return players
        }

        return players.filter { $0.id != currentPlayer.id }
    }

    func player(id: Int) -> Player? {
        players.filter { $0.id == id }
            .first
    }

    func with(currentPlayerId: Int? = nil, mexicanTrain: Train? = nil, players: [Player]? = nil, pool: [UnplayedDomino]? = nil) -> Game {
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

    func with(updatedPlayer: Player, mexicanTrain: Train? = nil, pool: [UnplayedDomino]? = nil) -> Game {
        let updatedPlayers = players.map { $0.id == updatedPlayer.id ? updatedPlayer : $0 }
        return with(mexicanTrain: mexicanTrain, players: updatedPlayers, pool: pool)
    }
}
