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

class PlaceDominoOnMexicanTrainOperationTests: XCTestCase {
    private var game: GameData!
    private var engine: FakeGameEngine!
    private var operation: PlaceDominoOnMexicanTrainOperation!

    override func setUp() {
        super.setUp()

        game = createTestGameData()
        engine = FakeGameEngine(gameData: game, localPlayerId: "P1")
        operation = PlaceDominoOnMexicanTrainOperation()
    }

    override func tearDown() {
        game = nil
        engine = nil
        operation = nil

        super.tearDown()
    }

    func testPerformOperation_invalidDomino() {
        let state = engine.createInitialState()
        let unownedDomino = UnplayedDomino(value1: .five, value2: .eleven)
        XCTAssertNil(operation.perform(game: state, domino: unownedDomino))
    }

    func testPerformOperation_removesDominoFromPlayer() {
        let state = engine.createInitialState()
        let updatedGame = operation.perform(game: state, domino: unplayed1)!
        let updatedPlayer = updatedGame.player(id: "P1")!
        XCTAssertEqual(updatedPlayer.dominoes.count, 1)
        XCTAssertFalse(updatedPlayer.dominoes.contains(unplayed1))
    }

    func testPerformOperation_addsDominoToTrain() {
        let state = engine.createInitialState()
        let updatedGame = operation.perform(game: state, domino: unplayed1)!
        let updatedTrain = updatedGame.mexicanTrain
        XCTAssertEqual(updatedTrain.dominoes.count, 2)
        XCTAssertEqual(updatedTrain.dominoes[1].outerValue, .six)
    }

    private func createTestGameData() -> GameData {
        let player1 = createPlayer(id: "P1", dominoes: [unplayed1, unplayed2], train: [playerPlayed])
        return createGame(stationValue: .twelve,
                          players: [player1],
                          mexicanTrain: [mexicanplayed])
    }
}
