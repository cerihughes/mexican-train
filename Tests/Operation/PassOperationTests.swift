//
//  PassOperationTests.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import XCTest

@testable import MexicanTrain

class PassOperationTests: XCTestCase {
    private var ruleSet: MockRuleSet!
    private var operation: PassOperation!

    override func setUp() {
        super.setUp()

        ruleSet = MockRuleSet()
        ruleSet.hasValidPlay = false
        operation = PassOperation(ruleSet: ruleSet)
    }

    override func tearDown() {
        ruleSet = nil
        operation = nil

        super.tearDown()
    }

    func testPerformOperation_withValidMove() {
        ruleSet.hasValidPlay = true
        let game1 = createTestGameData()
        let game2 = operation.perform(game: game1.createInitialState())
        XCTAssertNil(game2)
    }

    func testPerformOperation_withRemainingPool() {
        let game1 = createTestGameData(pool: [UnplayedDomino(value1: .twelve, value2: .nine)])
        let game2 = operation.perform(game: game1.createInitialState())
        XCTAssertNil(game2)
    }

    private func createTestGameData(pool: [UnplayedDomino] = []) -> GameData {
        let player1 = createPlayer(id: "P1", domino: UnplayedDomino(value1: .six, value2: .nine))
        let player2 = createPlayer(id: "P2", domino: UnplayedDomino(value1: .six, value2: .ten))
        return createGame(players: [player1, player2], pool: pool)
    }
}
