//
//  AddPlayerOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import UIKit

class AddPlayerOperation {
    private let shuffler: Shuffler

    init(shuffler: Shuffler) {
        self.shuffler = shuffler
    }

    func perform(game: Game, playerDetails: PlayerData.Details) -> GameData {
        var pool = game.gameData.pool
        let player = PlayerData(details: playerDetails,
                                dominoes: pool.removeRandomElements(15, using: shuffler),
                                train: Train(isPlayable: false, dominoes: []))
        var players = game.gameData.players
        players.append(player)
        return game.gameData.with(players: players, pool: pool)
    }
}
