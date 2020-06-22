//
//  JoinGameOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import UIKit

class JoinGameOperation {
    private let shuffler: Shuffler

    init(shuffler: Shuffler) {
        self.shuffler = shuffler
    }

    func perform(game: Game, playerId: String) -> Game {
        var pool = game.pool
        let player = Player(id: playerId,
                            dominoes: pool.removeRandomElements(15, using: shuffler),
                            train: Train(isPlayable: false, dominoes: []),
                            currentTurn: [],
                            score: 0)
        var players = game.players
        players.append(player)
        return game.with(players: players, pool: pool)
    }
}
