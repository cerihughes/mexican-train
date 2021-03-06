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
    let openGates: [DominoValue]

    private enum CodingKeys: String, CodingKey {
        case stationValue = "s"
        case mexicanTrain = "mt"
        case players = "ps"
        case pool = "p"
        case openGates = "g"
    }
}

extension Game {
    func with(stationValue: DominoValue? = nil,
              mexicanTrain: Train? = nil,
              players: [Player]? = nil,
              pool: [UnplayedDomino]? = nil,
              openGates: [DominoValue]? = nil) -> Game {
        Game(stationValue: stationValue ?? self.stationValue,
             mexicanTrain: mexicanTrain ?? self.mexicanTrain,
             players: players ?? self.players,
             pool: pool ?? self.pool,
             openGates: openGates ?? self.openGates)
    }

    func with(stationValue: DominoValue? = nil,
              mexicanTrain: Train? = nil,
              updatedPlayer: Player,
              pool: [UnplayedDomino]? = nil,
              openGates: [DominoValue]? = nil) -> Game {
        with(stationValue: stationValue,
             mexicanTrain: mexicanTrain,
             players: players.map { $0.id == updatedPlayer.id ? updatedPlayer : $0 },
             pool: pool,
             openGates: openGates)
    }

    func withUpdatedScores() -> Game {
        let updatedPlayers = players.map { $0.withUpdatedScore() }
        return with(players: updatedPlayers)
    }
}
