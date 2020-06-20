//
//  GameData.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct GameData: Equatable, Codable {
    let stationValue: DominoValue
    let mexicanTrain: Train
    let players: [PlayerData]
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

extension GameData {
    func player(id: String) -> PlayerData? {
        players.filter { $0.id == id }
            .first
    }

    func with(mexicanTrain: Train? = nil, players: [PlayerData]? = nil, pool: [UnplayedDomino]? = nil, openGates: [DominoValue]? = nil) -> GameData {
        GameData(stationValue: stationValue,
                 mexicanTrain: mexicanTrain ?? self.mexicanTrain,
                 players: players ?? self.players,
                 pool: pool ?? self.pool,
                 openGates: openGates ?? self.openGates)
    }

    func with(updatedPlayer: PlayerData, mexicanTrain: Train? = nil, pool: [UnplayedDomino]? = nil, openGates: [DominoValue]? = nil) -> GameData {
        let updatedPlayers = players.map { $0.id == updatedPlayer.id ? updatedPlayer : $0 }
        return with(mexicanTrain: mexicanTrain, players: updatedPlayers, pool: pool, openGates: openGates)
    }
}
