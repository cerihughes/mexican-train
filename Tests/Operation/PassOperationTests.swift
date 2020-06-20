//
//  PassOperationTests.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import XCTest

@testable import MexicanTrain

class PassOperationTests: XCTestCase {
    private var operation: PassOperation!

    override func setUp() {
        super.setUp()

        operation = PassOperation()
    }

    override func tearDown() {
        operation = nil

        super.tearDown()
    }

    func testPerformOperation_withValidMove() {
        let player1 = createPlayer(id: "P1", domino: UnplayedDomino(value1: .zero, value2: .nine))
        let player2 = createPlayer(id: "P2", domino: UnplayedDomino(value1: .six, value2: .ten))
        let game1 = createGame(players: [player1, player2], pool: [])

        let engine = FakeGameEngine(gameData: game1, localPlayerId: "P1")
        let state = engine.createInitialState()
        let game2 = operation.perform(game: state)
        XCTAssertNil(game2)
    }

    func testPerformOperation_withRemainingPool() {
        let player1 = createPlayer(id: "P1", domino: UnplayedDomino(value1: .six, value2: .nine))
        let player2 = createPlayer(id: "P2", domino: UnplayedDomino(value1: .six, value2: .ten))
        let pool = [UnplayedDomino(value1: .twelve, value2: .nine)]
        let game1 = createGame(players: [player1, player2], pool: pool)
        let engine = FakeGameEngine(gameData: game1, localPlayerId: "P1")
        let state = engine.createInitialState()
        let game2 = operation.perform(game: state)
        XCTAssertNil(game2)
    }
}
