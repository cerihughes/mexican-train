//
//  StartLevelOperationTests.swift
//  Tests
//
//  Created by Ceri on 31/05/2020.
//

import XCTest

@testable import MexicanTrain

class StartLevelOperationTests: OperationTestCase {
    private var initialGame: Game!
    private var operation: StartLevelOperation!

    override func setUp() {
        super.setUp()
        let player = createPlayer(id: "P1", dominoes: [])
        initialGame = Game.empty
            .with(players: [player])
        operation = StartLevelOperation(gameEngine: gameEngine, shuffler: shuffler)
        gameEngine.createState(localPlayerId: "P1")
    }

    override func tearDown() {
        operation = nil
        super.tearDown()
    }

    func testDominoDistribution() {
        let game = operation.perform(game: initialGame, stationValue: .twelve)
        XCTAssertEqual(game.pool.count, 75)
        XCTAssertEqual(game.players.count, 1)
        XCTAssertEqual(game.players[0].dominoes.count, 15)
        XCTAssertEqual(game.mexicanTrain.dominoes.count, 0)
        XCTAssertEqual(game.players[0].train.dominoes.count, 0)
    }

    func testRandomPickups() {
        let game = operation.perform(game: initialGame, stationValue: .twelve)
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
