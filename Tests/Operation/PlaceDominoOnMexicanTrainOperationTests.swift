//
//  PlaceDominoOnMexicanTrainOperationTests.swift
//  Tests
//
//  Created by Ceri on 16/05/2020.
//

import XCTest

@testable import MexicanTrain

private let mexicanplayed = PlayedDomino(innerValue: .twelve, outerValue: .five)
private let playerPlayed = PlayedDomino(innerValue: .twelve, outerValue: .seven)
private let unplayed1 = UnplayedDomino(value1: .five, value2: .six)
private let unplayed2 = UnplayedDomino(value1: .five, value2: .seven)

class PlaceDominoOnMexicanTrainOperationTests: OperationTestCase {
    private var game: Game!
    private var operation: PlaceDominoOnMexicanTrainOperation!

    override func setUp() {
        super.setUp()

        game = createTestGame()
        operation = PlaceDominoOnMexicanTrainOperation(gameEngine: gameEngine)
        gameEngine.createState(localPlayerId: "P1")
    }

    override func tearDown() {
        game = nil
        operation = nil

        super.tearDown()
    }

    func testPerformOperation_invalidDomino() {
        let unownedDomino = UnplayedDomino(value1: .five, value2: .eleven)
        XCTAssertNil(operation.perform(game: game, domino: unownedDomino))
    }

    func testPerformOperation_removesDominoFromPlayer() {
        let updatedGame = operation.perform(game: game, domino: unplayed1)!
        let updatedPlayer = updatedGame.player(id: "P1")!
        XCTAssertEqual(updatedPlayer.dominoes.count, 1)
        XCTAssertFalse(updatedPlayer.dominoes.contains(unplayed1))
    }

    func testPerformOperation_addsDominoToTrain() {
        let updatedGame = operation.perform(game: game, domino: unplayed1)!
        let updatedTrain = updatedGame.mexicanTrain
        XCTAssertEqual(updatedTrain.dominoes.count, 2)
        XCTAssertEqual(updatedTrain.dominoes[1].outerValue, .six)
    }

    private func createTestGame() -> Game {
        let player1 = createPlayer(id: "P1", dominoes: [unplayed1, unplayed2], train: [playerPlayed])
        return createGame(stationValue: .twelve,
                          players: [player1],
                          mexicanTrain: [mexicanplayed])
    }
}
