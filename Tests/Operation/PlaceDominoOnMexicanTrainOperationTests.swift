//
//  PlaceDominoOnMexicanTrainOperationTests.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import XCTest

@testable import MexicanTrain

private let player1Domino = UnplayedDomino(value1: .five, value2: .six)
private let player2Domino = UnplayedDomino(value1: .five, value2: .seven)

class PlaceDominoOnMexicanTrainOperationTests: XCTestCase {
    private var ruleSet: MockRuleSet!
    private var game: GameData!
    private var engine: FakeGameEngine!
    private var operation: PlaceDominoOnMexicanTrainOperation!

    override func setUp() {
        super.setUp()

        ruleSet = MockRuleSet()
        game = createTestGameData()
        engine = FakeGameEngine(gameData: game, localPlayerId: "P1")
        operation = PlaceDominoOnMexicanTrainOperation(ruleSet: ruleSet)
    }

    override func tearDown() {
        ruleSet = nil
        game = nil
        engine = nil
        operation = nil

        super.tearDown()
    }

    func testPerformOperation_invalidTurn() {
        ruleSet.canPlay = false
        let state = engine.createInitialState()
        XCTAssertNil(operation.perform(game: state, domino: player1Domino))
    }

    func testPerformOperation_invalidDomino() {
        let state = engine.createInitialState()
        XCTAssertNil(operation.perform(game: state, domino: player2Domino))
    }

    func testPerformOperation_removesDominoFromPlayer() {
        let state = engine.createInitialState()
        let updatedGame = operation.perform(game: state, domino: player1Domino)!
        let updatedPlayer = updatedGame.player(id: "P1")!
        XCTAssertEqual(updatedPlayer.dominoes.count, 0)
        XCTAssertFalse(updatedPlayer.dominoes.contains(player1Domino))
    }

    func testPerformOperation_addsDominoToTrain() {
        let state = engine.createInitialState()
        let updatedGame = operation.perform(game: state, domino: player1Domino)!
        let updatedTrain = updatedGame.mexicanTrain
        XCTAssertEqual(updatedTrain.dominoes.count, 2)
        XCTAssertEqual(updatedTrain.dominoes[1].outerValue, .six)
    }

    private func createTestGameData() -> GameData {
        let player1 = createPlayer(id: "P1", domino: player1Domino)
        let player2 = createPlayer(id: "P2", domino: player2Domino)
        return createGame(stationValue: .twelve,
                          players: [player1, player2],
                          mexicanTrain: [PlayedDomino(innerValue: .twelve, outerValue: .five)])
    }
}
