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
        let operation = createOperation(domino: player1Domino)
        ruleSet.canPlay = false
        XCTAssertNil(operation.perform(game: game))
    }

    func testPerformOperation_invalidDomino() {
        let operation = createOperation(domino: player2Domino)
        XCTAssertNil(operation.perform(game: game))
    }

    func testPerformOperation_incrementsCurrentPlayer() {
        let operation = createOperation(domino: player1Domino)
        let updatedGame = operation.perform(game: game)!
        XCTAssertEqual(updatedGame.currentPlayerId, 2)
    }

    func testPerformOperation_removesDominoFromPlayer() {
        let operation = createOperation(domino: player1Domino)
        let updatedGame = operation.perform(game: game)!
        let updatedPlayer = updatedGame.player(id: 1)!
        XCTAssertEqual(updatedPlayer.dominoes.count, 0)
        XCTAssertFalse(updatedPlayer.dominoes.contains(player1Domino))
    }

    func testPerformOperation_addsDominoToTrain() {
        let operation = createOperation(domino: player1Domino)
        let updatedGame = operation.perform(game: game)!
        let updatedTrain = updatedGame.mexicanTrain
        XCTAssertEqual(updatedTrain.dominoes.count, 2)
        XCTAssertEqual(updatedTrain.dominoes[1].outerValue, .six)
    }

    private func createTestGameData() -> Game {
        let player1 = createPlayer(id: 1, domino: player1Domino)
        let player2 = createPlayer(id: 2, domino: player2Domino)
        return createGame(stationValue: .twelve,
                          players: [player1, player2],
                          mexicanTrain: [PlayedDomino(innerValue: .twelve, outerValue: .five)])
    }

    private func createOperation(domino: UnplayedDomino) -> PlaceDominoOnMexicanTrainOperation {
        return PlaceDominoOnMexicanTrainOperation(ruleSet: ruleSet, domino: domino)
    }
}
