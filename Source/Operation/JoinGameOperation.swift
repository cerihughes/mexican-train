//
//  JoinGameOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import UIKit

class JoinGameOperation: Operation {
    private let shuffler: Shuffler

    init(gameEngine: GameEngine, shuffler: Shuffler) {
        self.shuffler = shuffler
        super.init(gameEngine: gameEngine)
    }

    func perform(game: Game) -> Game? {
        guard let localPlayerId = gameEngine.engineState?.localPlayerId else { return nil }
        var pool = game.pool
        let player = Player(id: localPlayerId,
                            dominoes: pool.removeRandomElements(15, using: shuffler),
                            train: Train(isPlayable: false, dominoes: []),
                            currentTurn: [],
                            score: 0)
        var players = game.players
        players.append(player)
        return game.with(players: players, pool: pool)
    }
}
