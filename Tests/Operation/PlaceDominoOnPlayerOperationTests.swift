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

class PlaceDominoOnPlayerOperationTests: OperationTestCase {
    private var game: Game!
    private var operation: PlaceDominoOnPlayerOperation!

    override func setUp() {
        super.setUp()

        game = createTestGame()
        operation = PlaceDominoOnPlayerOperation(gameEngine: gameEngine)
        gameEngine.createState(localPlayerId: "P1")
    }

    override func tearDown() {
        game = nil
        operation = nil

        super.tearDown()
    }

    func testPerformOperation_invalidTurn() {
        XCTAssertNil(operation.perform(game: game, domino: player2Domino, playerId: "P2"))
    }

    func testPerformOperation_invalidDomino() {
        XCTAssertNil(operation.perform(game: game, domino: player2Domino, playerId: "P1"))
    }

    func testPerformOperation_samePlayer_removesDominoFromPlayer() {
        let updatedGame = operation.perform(game: game, domino: player1Domino, playerId: "P1")!
        let updatedPlayer = updatedGame.player(id: "P1")!
        XCTAssertEqual(updatedPlayer.dominoes.count, 0)
        XCTAssertFalse(updatedPlayer.dominoes.contains(player1Domino))
    }

    func testPerformOperation_samePlayer_addsDominoToTrain() {
        let updatedGame = operation.perform(game: game, domino: player1Domino, playerId: "P1")!
        let updatedTrain = updatedGame.player(id: "P1")!.train
        XCTAssertEqual(updatedTrain.dominoes.count, 2)
        XCTAssertEqual(updatedTrain.dominoes[1].outerValue, .six)
    }

    private func createTestGame() -> Game {
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
