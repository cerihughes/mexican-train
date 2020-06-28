//
//  OperationTestCase.swift
//  Tests
//
//  Created by Ceri on 23/06/2020.
//

import XCTest

@testable import MexicanTrain

class OperationTestCase: XCTestCase {
    var gameEngine: MockGameEngine!
    var shuffler: MockShuffler!

    override func setUp() {
        super.setUp()

        gameEngine = MockGameEngine()
        shuffler = MockShuffler()
    }

    override func tearDown() {
        shuffler = nil
        gameEngine = nil

        super.tearDown()
    }
}
