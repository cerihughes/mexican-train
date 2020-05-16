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
        let game1 = createTestGameData()
        XCTAssertFalse(game1.currentPlayer!.train.playable)

        let game2 = operation.perform(game: game1)!
        XCTAssertTrue(game2.currentPlayer!.train.playable)

        let game3 = operation.perform(game: game2)!
        XCTAssertFalse(game3.currentPlayer!.train.playable)
    }
}
