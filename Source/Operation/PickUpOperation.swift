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

    func perform(game: Game) -> GameData? {
        var pool = game.gameData.pool
        guard game.currentLocalPlayerHasValidPlay == false,
            let currentPlayer = game.currentLocalPlayer, let domino = pool.removeRandomElement(using: shuffler) else {
            return nil
        }

        let updatedPlayer = currentPlayer.with(domino: domino)
        return game.gameData.with(updatedPlayer: updatedPlayer, pool: pool)
    }
}
