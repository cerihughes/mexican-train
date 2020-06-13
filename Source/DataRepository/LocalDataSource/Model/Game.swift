//
//  Game.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct Game: Equatable, Codable {
    let stationValue: DominoValue
    let currentPlayerId: String
    let initialPlayerId: String
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

        return players.filter { $0.details.id != currentPlayer.details.id }
    }

    func player(id: String) -> Player? {
        players.filter { $0.details.id == id }
            .first
    }

    func with(currentPlayerId: String? = nil, mexicanTrain: Train? = nil, players: [Player]? = nil, pool: [UnplayedDomino]? = nil) -> Game {
        Game(stationValue: stationValue,
             currentPlayerId: currentPlayerId ?? self.currentPlayerId,
             initialPlayerId: initialPlayerId,
             mexicanTrain: mexicanTrain ?? self.mexicanTrain,
             players: players ?? self.players,
             pool: pool ?? self.pool)
    }

    func withIncrementedPlayer() -> Game? {
        guard let currentIndex = players.firstIndex(where: { $0.details.id == currentPlayerId }),
            let nextPlayer = players[safe: currentIndex + 1] ?? players.first else {
            return nil
        }

        return with(currentPlayerId: nextPlayer.details.id)
    }

    func with(updatedPlayer: Player, mexicanTrain: Train? = nil, pool: [UnplayedDomino]? = nil) -> Game {
        let updatedPlayers = players.map { $0.details.id == updatedPlayer.details.id ? updatedPlayer : $0 }
        return with(mexicanTrain: mexicanTrain, players: updatedPlayers, pool: pool)
    }
}
