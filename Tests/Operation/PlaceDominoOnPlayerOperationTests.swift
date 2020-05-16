//
//  PlaceDominoOnPlayerOperationTests.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import XCTest

@testable import MexicanTrain

class PlaceDominoOnPlayerOperationTests: XCTestCase {
    private var ruleSet: MockRuleSet!
    private var game: Game!

    override func setUp() {
        super.setUp()

        ruleSet = MockRuleSet()
        game = createTestGameData()
    }

    override func tearDown() {
        ruleSet = nil
        game = nil

        super.tearDown()
    }

    func testPerformOperation_invalidTurn() {
        let domino = game.currentPlayer!.dominoes.first!
        let operation = createOperation(domino: domino)
        ruleSet.canPlay = false
        XCTAssertNil(operation.perform(game: game))
    }

    func testPerformOperation_invalidDomino() {
        let domino = game.player(id: 2)!.dominoes.first!
        let operation = createOperation(domino: domino)
        XCTAssertNil(operation.perform(game: game))
    }

    func testPerformOperation_incrementsCurrentPlayer() {
        let domino = game.currentPlayer!.dominoes.first!
        let operation = createOperation(domino: domino)
        let updatedGame = operation.perform(game: game)!
        XCTAssertEqual(updatedGame.currentPlayerId, 2)
    }

    func testPerformOperation_samePlayer_removesDominoFromPlayer() {
        let domino = game.currentPlayer!.dominoes.first!
        let operation = createOperation(domino: domino)
        let updatedGame = operation.perform(game: game)!
        let updatedPlayer = updatedGame.player(id: 1)!
        XCTAssertEqual(updatedPlayer.dominoes.count, 3)
        XCTAssertFalse(updatedPlayer.dominoes.contains(domino))
    }

    func testPerformOperation_samePlayer_addsDominoToTrain() {
        let domino = game.currentPlayer!.dominoes.first!
        let operation = createOperation(domino: domino)
        let updatedGame = operation.perform(game: game)!
        let updatedTrain = updatedGame.player(id: 1)!.train
        XCTAssertEqual(updatedTrain.dominoes.count, 1)
        XCTAssertEqual(updatedTrain.dominoes[0], domino)
    }

    func testPerformOperation_differentPlayer_removesDominoFromPlayer() {
        let domino = game.currentPlayer!.dominoes.first!
        let operation = createOperation(domino: domino, playerId: 2)
        let updatedGame = operation.perform(game: game)!
        let updatedPlayer = updatedGame.player(id: 1)!
        XCTAssertEqual(updatedPlayer.dominoes.count, 3)
        XCTAssertFalse(updatedPlayer.dominoes.contains(domino))
    }

    func testPerformOperation_differentPlayer_addsDominoToTrain() {
        let domino = game.currentPlayer!.dominoes.first!
        let operation = createOperation(domino: domino, playerId: 2)
        let updatedGame = operation.perform(game: game)!
        let updatedTrain = updatedGame.player(id: 2)!.train
        XCTAssertEqual(updatedTrain.dominoes.count, 1)
        XCTAssertEqual(updatedTrain.dominoes[0], domino)
    }

    private func createOperation(domino: Domino, playerId: Int? = nil) -> PlaceDominoOnPlayerOperation {
        return PlaceDominoOnPlayerOperation(ruleSet: ruleSet, domino: domino, playerId: playerId ?? game.currentPlayerId)
    }
}
