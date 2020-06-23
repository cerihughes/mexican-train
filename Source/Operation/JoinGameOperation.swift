//
//  JoinGameOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import UIKit

class JoinGameOperation {
    func perform(game: Game, playerId: String) -> GameData {
        let player = PlayerData(id: playerId)
        var players = game.gameData.players
        players.append(player)
        return game.gameData.with(players: players)
    }
}
