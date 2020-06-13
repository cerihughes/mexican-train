//
//  AddPlayerOperationTests.swift
//  Tests
//
//  Created by Ceri on 13/06/2020.
//

import XCTest

@testable import MexicanTrain

class AddPlayerOperationTests: XCTestCase {
    private var shuffler: MockShuffler!
    private var setupOperation: SetupGameOperation!
    private var addOperation: AddPlayerOperation!

    override func setUp() {
        super.setUp()
        shuffler = MockShuffler()
        setupOperation = SetupGameOperation(shuffler: shuffler)
        addOperation = AddPlayerOperation(shuffler: shuffler)
    }

    override func tearDown() {
        addOperation = nil
        setupOperation = nil
        shuffler = nil
        super.tearDown()
    }

    func testDominoDistribution() {
        let game1 = setupOperation.perform(playerDetails: createPlayerDetails(id: "P1"))
        var state = game1.createInitialState()
        XCTAssertEqual(state.currentPlayerId, "P1")

        let game2 = addOperation.perform(gameState: state, playerDetails: createPlayerDetails(id: "P2"))
        state = state.incrementedState(game: game2)
        XCTAssertEqual(state.currentPlayerId, "P2")

        let game3 = addOperation.perform(gameState: state, playerDetails: createPlayerDetails(id: "P3"))
        state = state.incrementedState(game: game3)
        XCTAssertEqual(state.currentPlayerId, "P3")

        let game4 = addOperation.perform(gameState: state, playerDetails: createPlayerDetails(id: "P4"))
        state = state.incrementedState(game: game4)
        XCTAssertEqual(state.currentPlayerId, "P4")

        XCTAssertEqual(game4.pool.count, 30)
        XCTAssertEqual(game4.players.count, 4)
        XCTAssertEqual(game4.players[0].dominoes.count, 15)
        XCTAssertEqual(game4.players[1].dominoes.count, 15)
        XCTAssertEqual(game4.players[2].dominoes.count, 15)
        XCTAssertEqual(game4.players[3].dominoes.count, 15)
        XCTAssertEqual(game4.mexicanTrain.dominoes.count, 0)
        XCTAssertEqual(game4.players[0].train.dominoes.count, 0)
        XCTAssertEqual(game4.players[1].train.dominoes.count, 0)
        XCTAssertEqual(game4.players[2].train.dominoes.count, 0)
        XCTAssertEqual(game4.players[3].train.dominoes.count, 0)
    }

    func testRandomPickups() {
        let game1 = setupOperation.perform(playerDetails: createPlayerDetails(id: "P1"))
        var state = game1.createInitialState()
        XCTAssertEqual(state.currentPlayerId, "P1")

        let game2 = addOperation.perform(gameState: state, playerDetails: createPlayerDetails(id: "P2"))
        state = state.incrementedState(game: game2)
        XCTAssertEqual(state.currentPlayerId, "P2")

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

        XCTAssertEqual(game2.players.count, 2)
        XCTAssertEqual(game2.players[0].dominoes, expectedPlayer1Dominoes)
        XCTAssertEqual(game2.players[1].dominoes, expectedPlayer2Dominoes)
    }
}

private func domino(_ value1: DominoValue, _ value2: DominoValue) -> UnplayedDomino {
    UnplayedDomino(value1: value1, value2: value2)
}