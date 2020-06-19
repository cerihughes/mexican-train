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
        let game = createGame(stationValue: .twelve, playerId: "P1", playerDominoes: [UnplayedDomino(value1: .zero, value2: .one)])
        let engine = FakeGameEngine(gameData: game, localPlayerId: "P1")
        let state = engine.createInitialState()
        XCTAssertFalse(ruleSet.currentPlayerHasValidPlay(in: state))
    }

    func testHasValidPlay_noTrains_withStarter() {
        let game = createGame(stationValue: .twelve, playerId: "P1", playerDominoes: [UnplayedDomino(value1: .zero, value2: .twelve)])
        let engine = FakeGameEngine(gameData: game, localPlayerId: "P1")
        let state = engine.createInitialState()
        XCTAssertTrue(ruleSet.currentPlayerHasValidPlay(in: state))
    }

    func testHasValidPlay_validTrain_noStarter() {
        let game = createGame(stationValue: .twelve,
                              playerId: "P1",
                              playerDominoes: [UnplayedDomino(value1: .zero, value2: .one)],
                              mexicanTrain: [PlayedDomino(innerValue: .twelve, outerValue: .zero)])
        let engine = FakeGameEngine(gameData: game, localPlayerId: "P1")
        let state = engine.createInitialState()
        XCTAssertFalse(ruleSet.currentPlayerHasValidPlay(in: state))
    }

    func testHasValidPlay_validTrain_withStarter() throws {
        let game = createGame(stationValue: .twelve,
                              playerId: "P1",
                              playerDominoes: [UnplayedDomino(value1: .zero, value2: .one)],
                              playerTrain: [PlayedDomino(innerValue: .twelve, outerValue: .eleven)],
                              mexicanTrain: [PlayedDomino(innerValue: .twelve, outerValue: .zero)])
        let engine = FakeGameEngine(gameData: game, localPlayerId: "P1")
        let state = engine.createInitialState()
        XCTAssertTrue(ruleSet.currentPlayerHasValidPlay(in: state))
    }
}
