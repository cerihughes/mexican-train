//
//  StandardRuleSetTests.swift
//  Tests
//
//  Created by Ceri on 17/05/2020.
//

import XCTest

@testable import MexicanTrain

class StandardRuleSetTests: XCTestCase {

    private var ruleSet: StandardRuleSet!

    override func setUp() {
        super.setUp()
        ruleSet = StandardRuleSet()
    }

    override func tearDown() {
        ruleSet = nil
        super.tearDown()
    }

    func testHasValidPlay_noTrains_noStarter() {
        let game = createGame(stationValue: .twelve, playerDominoes: [Domino(value1: .zero, value2: .one)])
        XCTAssertFalse(ruleSet.currentPlayerHasValidPlay(in: game))
    }

    func testHasValidPlay_noTrains_withStarter() {
        let game = createGame(stationValue: .twelve, playerDominoes: [Domino(value1: .zero, value2: .twelve)])
        XCTAssertTrue(ruleSet.currentPlayerHasValidPlay(in: game))
    }

    func testHasValidPlay_validTrain_noStarter() {
        let game = createGame(stationValue: .twelve,
                              playerDominoes: [Domino(value1: .zero, value2: .one)],
                              mexicanTrain: [Domino(value1: .zero, value2: .twelve)])
        XCTAssertFalse(ruleSet.currentPlayerHasValidPlay(in: game))
    }

    func testHasValidPlay_validTrain_withStarter() throws {
        let game = createGame(stationValue: .twelve,
                              playerDominoes: [Domino(value1: .zero, value2: .one)],
                              playerTrain:[Domino(value1: .twelve, value2: .eleven)],
                              mexicanTrain: [Domino(value1: .zero, value2: .twelve)])
        XCTAssertTrue(ruleSet.currentPlayerHasValidPlay(in: game))
    }
}
