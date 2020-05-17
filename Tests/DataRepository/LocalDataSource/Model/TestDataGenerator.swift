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
    return Game(stationValue: stationValue, currentPlayerId: 1, initialPlayerId: 1, mexicanTrain: mexicanTrain, players: players, pool: pool)
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

func createPlayer(id: Int = 1, name: String = "Player", dominoes: [UnplayedDomino], train: [PlayedDomino] = [], isPlayable: Bool = false) -> Player {
    let train = createTrain(isPlayable: isPlayable, dominoes: train)
    return Player(id: id, name: name, dominoes: dominoes, train: train)
}

func createPlayer(id: Int = 1, name: String = "Player", domino: UnplayedDomino, train: [PlayedDomino] = [], isPlayable: Bool = false) -> Player {
    createPlayer(id: id, name: name, dominoes: [domino], train: train, isPlayable: isPlayable)
}
