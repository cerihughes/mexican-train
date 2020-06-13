//
//  PassOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PassOperation {
    private let ruleSet: RuleSet

    init(ruleSet: RuleSet) {
        self.ruleSet = ruleSet
    }

    func perform(gameState: GameState) -> Game? {
        guard ruleSet.currentPlayerHasValidPlay(in: gameState) == false,
            gameState.game.pool.isEmpty else {
            return nil
        }

        return gameState.game
    }
}
