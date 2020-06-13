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

    func perform(gameState: GameState, playerDetails: Player.Details) -> Game {
        var pool = gameState.game.pool
        let player = Player(details: playerDetails,
                            dominoes: pool.removeRandomElements(15, using: shuffler),
                            train: Train(isPlayable: false, dominoes: []))
        var players = gameState.game.players
        players.append(player)
        return gameState.game.with(players: players, pool: pool)
    }
}
