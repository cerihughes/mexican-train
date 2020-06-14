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
}

extension GameData {
    func player(id: String) -> PlayerData? {
        players.filter { $0.details.id == id }
            .first
    }

    func with(mexicanTrain: Train? = nil, players: [PlayerData]? = nil, pool: [UnplayedDomino]? = nil) -> GameData {
        GameData(stationValue: stationValue,
                 mexicanTrain: mexicanTrain ?? self.mexicanTrain,
                 players: players ?? self.players,
                 pool: pool ?? self.pool)
    }

    func with(updatedPlayer: PlayerData, mexicanTrain: Train? = nil, pool: [UnplayedDomino]? = nil) -> GameData {
        let updatedPlayers = players.map { $0.details.id == updatedPlayer.details.id ? updatedPlayer : $0 }
        return with(mexicanTrain: mexicanTrain, players: updatedPlayers, pool: pool)
    }
}
