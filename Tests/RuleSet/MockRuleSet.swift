//
//  MockRuleSet.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

@testable import MexicanTrain

class MockRuleSet: RuleSet {
    var hasValidPlay = true
    var canPlay = true

    func currentPlayerHasValidPlay(in gameState: GameState) -> Bool {
        return hasValidPlay
    }

    func player(_ player: PlayerData, canPlay domino: UnplayedDomino, on train: Train, in gameState: GameState) -> Bool {
        return canPlay
    }
}
