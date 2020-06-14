//
//  PickUpOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

class PickUpOperation {
    private let ruleSet: RuleSet
    private let shuffler: Shuffler

    init(ruleSet: RuleSet, shuffler: Shuffler) {
        self.ruleSet = ruleSet
        self.shuffler = shuffler
    }

    func perform(gameState: GameState) -> GameData? {
        var pool = gameState.game.pool
        guard ruleSet.currentPlayerHasValidPlay(in: gameState) == false,
            let currentPlayer = gameState.currentPlayer, let domino = pool.removeRandomElement(using: shuffler) else {
            return nil
        }

        let updatedPlayer = currentPlayer.with(domino: domino)
        return gameState.game.with(updatedPlayer: updatedPlayer, pool: pool)
    }
}
