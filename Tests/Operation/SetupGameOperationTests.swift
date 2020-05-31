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
        let game = operation.perform(playerNames: ["Player1", "Player2", "Player3", "Player4"])
        XCTAssertEqual(game.pool.count, 30)
        XCTAssertEqual(game.players.count, 4)
        XCTAssertEqual(game.players[0].dominoes.count, 15)
        XCTAssertEqual(game.players[1].dominoes.count, 15)
        XCTAssertEqual(game.players[2].dominoes.count, 15)
        XCTAssertEqual(game.players[3].dominoes.count, 15)
        XCTAssertEqual(game.mexicanTrain.dominoes.count, 0)
        XCTAssertEqual(game.players[0].train.dominoes.count, 0)
        XCTAssertEqual(game.players[1].train.dominoes.count, 0)
        XCTAssertEqual(game.players[2].train.dominoes.count, 0)
        XCTAssertEqual(game.players[3].train.dominoes.count, 0)
    }

    func testRandomPickups() {
        let game = operation.perform(playerNames: ["Player1", "Player2"])
        let expectedPlayer1Dominoes = [
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
        let expectedPlayer2Dominoes = [
            domino(.seven, .eleven),
            domino(.seven, .ten),
            domino(.seven, .nine),
            domino(.seven, .eight),
            domino(.seven, .seven),
            domino(.six, .twelve),
            domino(.six, .eleven),
            domino(.six, .ten),
            domino(.six, .nine),
            domino(.six, .eight),
            domino(.six, .seven),
            domino(.six, .six),
            domino(.five, .twelve),
            domino(.five, .eleven),
            domino(.five, .ten)
        ]
        XCTAssertEqual(game.players.count, 2)
        XCTAssertEqual(game.players[0].dominoes, expectedPlayer1Dominoes)
        XCTAssertEqual(game.players[1].dominoes, expectedPlayer2Dominoes)
    }
}

private func domino(_ value1: DominoValue, _ value2: DominoValue) -> UnplayedDomino {
    UnplayedDomino(value1: value1, value2: value2)
}
