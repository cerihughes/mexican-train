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
    var gateThatMustBeClosed: DominoValue? {
        if hasAnyPlayerPlayedDoubleInThisTurn {
            return nil
        }
        return openGates.first
    }

    var hasAnyPlayerPlayedDoubleInThisTurn: Bool {
        !players.allSatisfy { !$0.hasPlayedDoubleInThisTurn }
    }

    func player(id: String) -> Player? {
        players.filter { $0.id == id }
            .first
    }

    func with(mexicanTrain: Train? = nil, players: [Player]? = nil, pool: [UnplayedDomino]? = nil, openGates: [DominoValue]? = nil) -> Game {
        Game(stationValue: stationValue,
                 mexicanTrain: mexicanTrain ?? self.mexicanTrain,
                 players: players ?? self.players,
                 pool: pool ?? self.pool,
                 openGates: openGates ?? self.openGates)
    }

    func with(updatedPlayer: Player, mexicanTrain: Train? = nil, pool: [UnplayedDomino]? = nil, openGates: [DominoValue]? = nil) -> Game {
        let updatedPlayers = players.map { $0.id == updatedPlayer.id ? updatedPlayer : $0 }
        return with(mexicanTrain: mexicanTrain, players: updatedPlayers, pool: pool, openGates: openGates)
    }
}
