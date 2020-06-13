//
//  ChangeTrainPlayableStateOperation.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import XCTest

@testable import MexicanTrain

class ChangeTrainPlayableStateOperationTests: XCTestCase {
    private var operation: ChangeTrainPlayableStateOperation!

    override func setUp() {
        super.setUp()

        operation = ChangeTrainPlayableStateOperation()
    }

    override func tearDown() {
        operation = nil

        super.tearDown()
    }

    func testPerformOperation_togglesPlayableState() {
        let player = createPlayer(domino: UnplayedDomino(value1: .six, value2: .nine))
        let game1 = createGame(players: [player])
        var state = game1.createInitialState()
        XCTAssertFalse(state.currentPlayer!.train.isPlayable)

        let game2 = operation.perform(gameState: state)!
        state = state.incrementedState(game: game2)
        XCTAssertTrue(state.currentPlayer!.train.isPlayable)

        let game3 = operation.perform(gameState: state)!
        state = state.incrementedState(game: game3)
        XCTAssertFalse(state.currentPlayer!.train.isPlayable)
    }
}
