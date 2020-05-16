//
//  MockRuleSet.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

@testable import MexicanTrain

class MockRuleSet: RuleSet {
    var canPlay = true

    func player(_ player: Player, canPlay domino: Domino, on train: [Domino], in game: Game) -> Bool {
        return canPlay
    }
}
