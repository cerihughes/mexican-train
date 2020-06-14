//
//  Game.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import Foundation

struct Game {
    let gameData: GameData
    let totalPlayerCount: Int
    let playerDetails: [PlayerDetails]
    let localPlayerId: String
    let currentPlayerId: String
}

extension Game {
    var currentLocalPlayer: PlayerData? {
        currentPlayerId == localPlayerId ? localPlayer : nil
    }

    var localPlayer: PlayerData? {
        gameData.player(id: localPlayerId)
    }

    var otherPlayers: [PlayerData] {
        guard let localPlayer = localPlayer else {
            return gameData.players
        }

        return gameData.players.filter { $0.id != localPlayer.id }
    }
}
