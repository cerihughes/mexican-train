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

    func testPerformOperation_incrementsCurrentPlayer() {
        let game1 = createTestGameData()
        XCTAssertEqual(game1.currentPlayerId, 1)

        let game2 = operation.perform(game: game1)!
        XCTAssertEqual(game2.currentPlayerId, 2)

        let game3 = operation.perform(game: game2)!
        XCTAssertEqual(game3.currentPlayerId, 1)
    }
}
