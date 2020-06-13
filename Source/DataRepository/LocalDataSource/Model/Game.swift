//
//  Game.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct Game: Equatable, Codable {
    let stationValue: DominoValue
    let mexicanTrain: Train
    let players: [Player]
    let pool: [UnplayedDomino]
}

extension Game {
    func player(id: String) -> Player? {
        players.filter { $0.details.id == id }
            .first
    }

    func with(mexicanTrain: Train? = nil, players: [Player]? = nil, pool: [UnplayedDomino]? = nil) -> Game {
        Game(stationValue: stationValue,
             mexicanTrain: mexicanTrain ?? self.mexicanTrain,
             players: players ?? self.players,
             pool: pool ?? self.pool)
    }

    func with(updatedPlayer: Player, mexicanTrain: Train? = nil, pool: [UnplayedDomino]? = nil) -> Game {
        let updatedPlayers = players.map { $0.details.id == updatedPlayer.details.id ? updatedPlayer : $0 }
        return with(mexicanTrain: mexicanTrain, players: updatedPlayers, pool: pool)
    }
}
