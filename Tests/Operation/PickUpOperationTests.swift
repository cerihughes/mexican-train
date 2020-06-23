//
//  PickUpOperationTests.swift
//  Tests
//
//  Created by Ceri on 10/05/2020.
//

import XCTest

@testable import MexicanTrain

class PickUpOperationTests: OperationTestCase {
    private var operation: PickUpOperation!

    override func setUp() {
        super.setUp()
        operation = PickUpOperation(gameEngine: gameEngine, shuffler: shuffler)
        gameEngine.createState(localPlayerId: "P1")
    }

    override func tearDown() {
        operation = nil
        super.tearDown()
    }

    func testPerformOperation() {
        let pool = UnplayedDomino.allDominoes()
        let player1 = createPlayer(id: "P1", domino: UnplayedDomino(value1: .six, value2: .nine))
        let player2 = createPlayer(id: "P2", dominoes: [])
        let game1 = createGame(players: [player1, player2], pool: pool)
        let game2 = operation.perform(game: game1)
        XCTAssertNotNil(game2)
    }

    func testPerformOperation_withValidMove() {
        let pool = UnplayedDomino.allDominoes()
        let player1 = createPlayer(id: "P1", domino: UnplayedDomino(value1: .zero, value2: .nine))
        let player2 = createPlayer(id: "P2", dominoes: [])
        let game1 = createGame(players: [player1, player2], pool: pool)
        let game2 = operation.perform(game: game1)
        XCTAssertNil(game2)
    }

    func testPerformOperation_addsDominoes() {
        let pool = UnplayedDomino.allDominoes()
        let player1 = createPlayer(id: "P1", dominoes: [])
        let player2 = createPlayer(id: "P2", dominoes: [])
        let game1 = createGame(players: [player1, player2], pool: pool)
        XCTAssertEqual(game1.pool.count, 91)
        XCTAssertEqual(game1.players[0].dominoes.count, 0)
        XCTAssertEqual(game1.players[1].dominoes.count, 0)

        let game2 = operation.perform(game: game1)!
        XCTAssertEqual(game2.pool.count, 90)
        XCTAssertEqual(game2.players[0].dominoes.count, 1)
        XCTAssertEqual(game2.players[1].dominoes.count, 0)

        gameEngine.updateState(localPlayerId: "P2")
        let game3 = operation.perform(game: game2)!
        XCTAssertEqual(game3.pool.count, 89)
        XCTAssertEqual(game3.players[0].dominoes.count, 1)
        XCTAssertEqual(game3.players[1].dominoes.count, 1)
    }
}
