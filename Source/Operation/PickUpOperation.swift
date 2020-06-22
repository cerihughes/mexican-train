//
//  PickUpOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

class PickUpOperation {
    private let shuffler: Shuffler

    init(shuffler: Shuffler) {
        self.shuffler = shuffler
    }

    func perform(currentPlayer: Player, game: Game) -> Game? {
        var pool = game.pool
        guard game.playerHasValidPlay(player: currentPlayer) == false,
            let domino = pool.removeRandomElement(using: shuffler) else {
            return nil
        }

        let updatedTrain = currentPlayer.train.with(isPlayable: true)
        let updatedPlayer = currentPlayer.with(domino: domino, train: updatedTrain)
        return game.with(updatedPlayer: updatedPlayer, pool: pool)
    }
}
