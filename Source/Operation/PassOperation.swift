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

    func perform(game: Game) -> Game? {
        guard ruleSet.currentPlayerHasValidPlay(in: game) == false,
            game.pool.isEmpty else {
            return nil
        }

        return game.withIncrementedPlayer()
    }
}
