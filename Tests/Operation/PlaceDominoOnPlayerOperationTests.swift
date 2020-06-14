//
//  PlaceDominoOnPlayerOperationTests.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import XCTest

@testable import MexicanTrain

private let player1Domino = UnplayedDomino(value1: .five, value2: .six)
private let player2Domino = UnplayedDomino(value1: .five, value2: .seven)

class PlaceDominoOnPlayerOperationTests: XCTestCase {
    private var ruleSet: MockRuleSet!
    private var game: GameData!
    private var operation: PlaceDominoOnPlayerOperation!

    override func setUp() {
        super.setUp()

        ruleSet = MockRuleSet()
        game = createTestGameData()
        operation = PlaceDominoOnPlayerOperation(ruleSet: ruleSet)
    }

    override func tearDown() {
        ruleSet = nil
        game = nil
        operation = nil

        super.tearDown()
    }

    func testPerformOperation_invalidTurn() {
        ruleSet.canPlay = false
        XCTAssertNil(operation.perform(gameState: game.createInitialState(), domino: player1Domino, playerId: "P1"))
    }

    func testPerformOperation_invalidDomino() {
        XCTAssertNil(operation.perform(gameState: game.createInitialState(), domino: player2Domino, playerId: "P1"))
    }

    func testPerformOperation_samePlayer_removesDominoFromPlayer() {
        let updatedGame = operation.perform(gameState: game.createInitialState(), domino: player1Domino, playerId: "P1")!
        let updatedPlayer = updatedGame.player(id: "P1")!
        XCTAssertEqual(updatedPlayer.dominoes.count, 0)
        XCTAssertFalse(updatedPlayer.dominoes.contains(player1Domino))
    }

    func testPerformOperation_samePlayer_addsDominoToTrain() {
        let updatedGame = operation.perform(gameState: game.createInitialState(), domino: player1Domino, playerId: "P1")!
        let updatedTrain = updatedGame.player(id: "P1")!.train
        XCTAssertEqual(updatedTrain.dominoes.count, 2)
        XCTAssertEqual(updatedTrain.dominoes[1].outerValue, .six)
    }

    func testPerformOperation_differentPlayer_removesDominoFromPlayer() {
        let updatedGame = operation.perform(gameState: game.createInitialState(), domino: player1Domino, playerId: "P2")!
        let updatedPlayer = updatedGame.player(id: "P1")!
        XCTAssertEqual(updatedPlayer.dominoes.count, 0)
        XCTAssertFalse(updatedPlayer.dominoes.contains(player1Domino))
    }

    func testPerformOperation_differentPlayer_addsDominoToTrain() {
        let updatedGame = operation.perform(gameState: game.createInitialState(), domino: player1Domino, playerId: "P2")!
        let updatedTrain = updatedGame.player(id: "P2")!.train
        XCTAssertEqual(updatedTrain.dominoes.count, 3)
        XCTAssertEqual(updatedTrain.dominoes[2].outerValue, .six)
    }

    private func createTestGameData() -> GameData {
        let player1 = createPlayer(id: "P1",
                                   domino: player1Domino,
                                   train: [PlayedDomino(innerValue: .twelve, outerValue: .five)])
        let player2 = createPlayer(id: "P2",
                                   domino: player2Domino,
                                   train: [PlayedDomino(innerValue: .twelve, outerValue: .eleven), PlayedDomino(innerValue: .eleven, outerValue: .five)])
        return createGame(stationValue: .twelve,
                          players: [player1, player2])
    }
}
