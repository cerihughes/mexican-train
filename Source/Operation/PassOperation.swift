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

    func perform(game: Game) -> GameData? {
        guard ruleSet.currentPlayerHasValidPlay(in: game) == false,
            game.gameData.pool.isEmpty else {
            return nil
        }

        return game.gameData
    }
}
