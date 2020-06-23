//
//  JoinGameOperationTests.swift
//  Tests
//
//  Created by Ceri on 13/06/2020.
//

import XCTest

@testable import MexicanTrain

class JoinGameOperationTests: OperationTestCase {
    private var initialGame: Game!
    private var startLevelOperation: StartLevelOperation!
    private var joinOperation: JoinGameOperation!

    override func setUp() {
        super.setUp()
        initialGame = Game.createInitialGame()
        startLevelOperation = StartLevelOperation(gameEngine: gameEngine, shuffler: shuffler)
        joinOperation = JoinGameOperation(gameEngine: gameEngine)
        gameEngine.createState(localPlayerId: "P1")
    }

    override func tearDown() {
        joinOperation = nil
        startLevelOperation = nil
        initialGame = nil
        super.tearDown()
    }

    func testDominoDistribution() {
        let game1 = joinOperation.perform(game: initialGame)!

        gameEngine.updateState(localPlayerId: "P2")
        let game2 = joinOperation.perform(game: game1)!

        gameEngine.updateState(localPlayerId: "P3")
        let game3 = joinOperation.perform(game: game2)!

        gameEngine.updateState(localPlayerId: "P4")
        let game4 = joinOperation.perform(game: game3)!

        let startedGame = startLevelOperation.perform(game: game4, stationValue: .twelve)

        XCTAssertEqual(startedGame.pool.count, 30)
        XCTAssertEqual(startedGame.players.count, 4)
        XCTAssertEqual(startedGame.players[0].id, "P1")
        XCTAssertEqual(startedGame.players[1].id, "P2")
        XCTAssertEqual(startedGame.players[2].id, "P3")
        XCTAssertEqual(startedGame.players[3].id, "P4")
        XCTAssertEqual(startedGame.mexicanTrain.dominoes.count, 0)

        startedGame.players.forEach {
            XCTAssertEqual($0.dominoes.count, 15)
            XCTAssertEqual($0.train.dominoes.count, 0)
        }
    }

    func testRandomPickups() {
        let game1 = joinOperation.perform(game: initialGame)!

        gameEngine.updateState(localPlayerId: "P2")
        let game2 = joinOperation.perform(game: game1)!

        let startedGame = startLevelOperation.perform(game: game2, stationValue: .twelve)

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

        XCTAssertEqual(startedGame.players.count, 2)
        XCTAssertEqual(startedGame.players[0].dominoes, expectedPlayer1Dominoes)
        XCTAssertEqual(startedGame.players[1].dominoes, expectedPlayer2Dominoes)
    }
}

private func domino(_ value1: DominoValue, _ value2: DominoValue) -> UnplayedDomino {
    UnplayedDomino(value1: value1, value2: value2)
}
