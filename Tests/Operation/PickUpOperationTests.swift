//
//  PickUpOperationTests.swift
//  Tests
//
//  Created by Ceri on 10/05/2020.
//

import XCTest

@testable import MexicanTrain

class PickUpOperationTests: XCTestCase {
    private var shuffler: MockShuffler!
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

    func testPerformOperation_withValidMove() {
        let pool = UnplayedDomino.allDominoes()
        let player1 = createPlayer(id: "P1", domino: UnplayedDomino(value1: .zero, value2: .nine))
        let player2 = createPlayer(id: "P2", dominoes: [])
        let game1 = createGame(players: [player1, player2], pool: pool)

        let engine = FakeGameEngine(gameData: game1, localPlayerId: "P1")
        let game2 = operation.perform(game: engine.createInitialState())
        XCTAssertNil(game2)
    }

    func testPerformOperation_addsDominoes() {
        let pool = UnplayedDomino.allDominoes()
        let player1 = createPlayer(id: "P1", dominoes: [])
        let player2 = createPlayer(id: "P2", dominoes: [])
        let game1 = createGame(players: [player1, player2], pool: pool)

        let engine1 = FakeGameEngine(gameData: game1, localPlayerId: "P1")
        let state1 = engine1.createInitialState()
        XCTAssertEqual(game1.pool.count, 91)
        XCTAssertEqual(game1.players[0].dominoes.count, 0)
        XCTAssertEqual(game1.players[1].dominoes.count, 0)

        let game2 = operation.perform(game: state1)!
        let engine2 = FakeGameEngine(gameData: game2, localPlayerId: "P2")
        let state2 = engine2.createInitialState()
        XCTAssertEqual(game2.pool.count, 90)
        XCTAssertEqual(game2.players[0].dominoes.count, 1)
        XCTAssertEqual(game2.players[1].dominoes.count, 0)

        let game3 = operation.perform(game: state2)!
        XCTAssertEqual(game3.pool.count, 89)
        XCTAssertEqual(game3.players[0].dominoes.count, 1)
        XCTAssertEqual(game3.players[1].dominoes.count, 1)
    }
}
