//
//  PickUpOperationTests.swift
//  Tests
//
//  Created by Ceri on 10/05/2020.
//

import XCTest

@testable import MexicanTrain

class PickUpOperationTests: XCTestCase {
    private var ruleSet: MockRuleSet!
    private var shuffler: MockShuffler!
    private var operation: PickUpOperation!

    override func setUp() {
        super.setUp()

        ruleSet = MockRuleSet()
        ruleSet.hasValidPlay = false
        shuffler = MockShuffler()
        operation = PickUpOperation(ruleSet: ruleSet, shuffler: shuffler)
    }

    override func tearDown() {
        ruleSet = nil
        operation = nil
        shuffler = nil

        super.tearDown()
    }

    func testPerformOperation_withValidMove() {
        ruleSet.hasValidPlay = true
        let game1 = createTestGameData()
        let game2 = operation.perform(gameState: game1.createInitialState())
        XCTAssertNil(game2)
    }

    func testPerformOperation_addsDominoes() {
        let game1 = createTestGameData()
        var state = game1.createInitialState()
        XCTAssertEqual(game1.pool.count, 91)
        XCTAssertEqual(game1.players[0].dominoes.count, 0)
        XCTAssertEqual(game1.players[1].dominoes.count, 0)

        let game2 = operation.perform(gameState: state)!
        state = state.incrementedState(game: game2)
        XCTAssertEqual(game2.pool.count, 90)
        XCTAssertEqual(game2.players[0].dominoes.count, 1)
        XCTAssertEqual(game2.players[1].dominoes.count, 0)

        let game3 = operation.perform(gameState: state)!
        XCTAssertEqual(game3.pool.count, 89)
        XCTAssertEqual(game3.players[0].dominoes.count, 1)
        XCTAssertEqual(game3.players[1].dominoes.count, 1)
    }

    private func createTestGameData() -> GameData {
        let pool = UnplayedDomino.allDominoes()
        let player1 = createPlayer(id: "P1", dominoes: [])
        let player2 = createPlayer(id: "P2", dominoes: [])
        return createGame(players: [player1, player2], pool: pool)
    }
}
