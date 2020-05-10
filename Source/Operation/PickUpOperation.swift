//
//  PickUpOperation.swift
//  MexicanTrain
//
//  Created by Home on 10/05/2020.
//

import Foundation

class PickUpOperation {
    private let shuffler: Shuffler

    init(shuffler: Shuffler) {
        self.shuffler = shuffler
    }

    func perform(game: Game) -> Game? {
        var pool = game.pool
        guard let currentPlayer = game.currentPlayer, let domino = pool.removeRandomElement(using: shuffler) else {
            return nil
        }

        let updatedPlayer = currentPlayer.with(domino: domino)
        return game.with(updatedPlayer: updatedPlayer, updatedPool: pool)
            .withIncrementedPlayer()
    }
}
