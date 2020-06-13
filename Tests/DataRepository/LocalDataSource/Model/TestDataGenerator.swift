//
//  TestDataGenerator.swift
//  Tests
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

@testable import MexicanTrain

func createGame(stationValue: DominoValue = .zero,
                players: [Player],
                mexicanTrain: [PlayedDomino] = [],
                pool: [UnplayedDomino] = []) -> Game {
    let mexicanTrain = Train(isPlayable: true, dominoes: mexicanTrain)
    return Game(stationValue: stationValue,
                mexicanTrain: mexicanTrain,
                players: players,
                pool: pool)
}

func createGame(stationValue: DominoValue = .zero,
                playerDominoes: [UnplayedDomino],
                playerTrain: [PlayedDomino] = [],
                mexicanTrain: [PlayedDomino] = [],
                pool: [UnplayedDomino] = []) -> Game {
    let player = createPlayer(dominoes: playerDominoes, train: playerTrain)
    return createGame(stationValue: stationValue, players: [player], mexicanTrain: mexicanTrain, pool: pool)
}

func createTrain(isPlayable: Bool = false, dominoes: [PlayedDomino] = []) -> Train {
    Train(isPlayable: isPlayable, dominoes: dominoes)
}

func createTrain(isPlayable: Bool = false, domino: PlayedDomino) -> Train {
    createTrain(isPlayable: isPlayable, dominoes: [domino])
}

func createPlayerDetails(id: String = "P1", name: String? = nil) -> Player.Details {
    Player.Details(id: id, name: name ?? "Player_" + id)
}

func createPlayer(id: String = "P1", name: String? = nil, dominoes: [UnplayedDomino], train: [PlayedDomino] = [], isPlayable: Bool = false) -> Player {
    let train = createTrain(isPlayable: isPlayable, dominoes: train)
    let details = createPlayerDetails(id: id, name: name)
    return Player(details: details, dominoes: dominoes, train: train)
}

func createPlayer(id: String = "P1", name: String? = nil, domino: UnplayedDomino, train: [PlayedDomino] = [], isPlayable: Bool = false) -> Player {
    createPlayer(id: id, name: name, dominoes: [domino], train: train, isPlayable: isPlayable)
}

extension Game {
    func createInitialState() -> GameState {
        GameState(game: self, currentPlayerId: players[0].details.id)
    }
}

extension GameState {
    func incrementedState(game: Game) -> GameState {
        let currentIndex = game.players.firstIndex(where: { $0.details.id == currentPlayerId })!
        let nextPlayer = game.players[safe: currentIndex + 1] ?? game.players.first!

        return GameState(game: game, currentPlayerId: nextPlayer.details.id)
    }
}
