//
//  PickUpOperationTests.swift
//  Tests
//
//  Created by Home on 10/05/2020.
//

import XCTest

@testable import MexicanTrain

class PickUpOperationTests: XCTestCase {
    private var shuffler: Shuffler!
    private var operation: PickUpOperation!

    override func setUp() {
        super.setUp()

        shuffler = MockShuffler()
        operation = PickUpOperation(shuffler: shuffler)
    }

    override func tearDown() {
        operation = nil
        shuffler = nil

        super.tearDown()
    }

    func testPerformOperation_incrementsCurrentPlayer() {
        let game1 = createTestGameData()
        XCTAssertEqual(game1.currentPlayerId, 1)

        let game2 = operation.perform(game: game1)!
        XCTAssertEqual(game2.currentPlayerId, 2)

        let game3 = operation.perform(game: game2)!
        XCTAssertEqual(game3.currentPlayerId, 1)
    }

    func testPerformOperation_addsDominoes() {
        let game1 = createTestGameData()
        XCTAssertEqual(game1.pool.count, 83)
        XCTAssertEqual(game1.players[0].dominoes.count, 4)
        XCTAssertEqual(game1.players[1].dominoes.count, 4)

        let game2 = operation.perform(game: game1)!
        XCTAssertEqual(game2.pool.count, 82)
        XCTAssertEqual(game2.players[0].dominoes.count, 5)
        XCTAssertEqual(game2.players[1].dominoes.count, 4)

        let game3 = operation.perform(game: game2)!
        XCTAssertEqual(game3.pool.count, 81)
        XCTAssertEqual(game3.players[0].dominoes.count, 5)
        XCTAssertEqual(game3.players[1].dominoes.count, 5)
    }
}
