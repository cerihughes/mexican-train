//
//  ChangeTrainPlayableStateOperation.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import XCTest

@testable import MexicanTrain

class ChangeTrainPlayableStateOperationTests: OperationTestCase {
    private var operation: ChangeTrainPlayableStateOperation!

    override func setUp() {
        super.setUp()
        operation = ChangeTrainPlayableStateOperation(gameEngine: gameEngine)
        gameEngine.createState(localPlayerId: "P1")
    }

    override func tearDown() {
        operation = nil
        super.tearDown()
    }

    func testPerformOperation_togglesPlayableState() {
        let player = createPlayer(id: "P1", domino: UnplayedDomino(value1: .six, value2: .nine))
        let game1 = createGame(players: [player])
        XCTAssertFalse(game1.players[0].train.isPlayable)

        let game2 = operation.perform(game: game1)!
        XCTAssertTrue(game2.players[0].train.isPlayable)

        let game3 = operation.perform(game: game2)!
        XCTAssertFalse(game3.players[0].train.isPlayable)
    }
}
