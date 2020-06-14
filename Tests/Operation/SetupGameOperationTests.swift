//
//  SetupGameOperationTests.swift
//  Tests
//
//  Created by Ceri on 31/05/2020.
//

import XCTest

@testable import MexicanTrain

class SetupGameOperationTests: XCTestCase {
    private var shuffler: MockShuffler!
    private var operation: SetupGameOperation!

    override func setUp() {
        super.setUp()
        shuffler = MockShuffler()
        operation = SetupGameOperation(shuffler: shuffler)
    }

    override func tearDown() {
        operation = nil
        shuffler = nil
        super.tearDown()
    }

    func testDominoDistribution() {
        let game = operation.perform(playerId: "P1")
        XCTAssertEqual(game.pool.count, 75)
        XCTAssertEqual(game.players.count, 1)
        XCTAssertEqual(game.players[0].dominoes.count, 15)
        XCTAssertEqual(game.mexicanTrain.dominoes.count, 0)
        XCTAssertEqual(game.players[0].train.dominoes.count, 0)
    }

    func testRandomPickups() {
        let game = operation.perform(playerId: "P1")
        let expectedDominoes = [
            domino(.eleven, .twelve),
            domino(.eleven, .eleven),
            domino(.ten, .twelve),
            domino(.ten, .eleven),
            domino(.ten, .ten),
            domino(.nine, .twelve),
            domino(.nine, .eleven),
            domino(.nine, .ten),
            domino(.nine, .nine),
            domino(.eight, .twelve),
            domino(.eight, .eleven),
            domino(.eight, .ten),
            domino(.eight, .nine),
            domino(.eight, .eight),
            domino(.seven, .twelve)
        ]
        XCTAssertEqual(game.players.count, 1)
        XCTAssertEqual(game.players[0].dominoes, expectedDominoes)
    }
}

private func domino(_ value1: DominoValue, _ value2: DominoValue) -> UnplayedDomino {
    UnplayedDomino(value1: value1, value2: value2)
}
