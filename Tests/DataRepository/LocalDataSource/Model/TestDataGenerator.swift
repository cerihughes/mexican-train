//
//  TestDataGenerator.swift
//  Tests
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

@testable import MexicanTrain

func createGame(stationValue: DominoValue = .zero,
                players: [PlayerData],
                mexicanTrain: [PlayedDomino] = [],
                pool: [UnplayedDomino] = []) -> GameData {
    let mexicanTrain = Train(isPlayable: true, dominoes: mexicanTrain)
    return GameData(stationValue: stationValue,
                    mexicanTrain: mexicanTrain,
                    players: players,
                    pool: pool,
                    openGates: [])
}

func createGame(stationValue: DominoValue = .zero,
                playerId: String,
                playerDominoes: [UnplayedDomino],
                playerTrain: [PlayedDomino] = [],
                mexicanTrain: [PlayedDomino] = [],
                pool: [UnplayedDomino] = []) -> GameData {
    let player = createPlayer(id: playerId, dominoes: playerDominoes, train: playerTrain)
    return createGame(stationValue: stationValue, players: [player], mexicanTrain: mexicanTrain, pool: pool)
}

func createTrain(isPlayable: Bool = false, dominoes: [PlayedDomino] = []) -> Train {
    Train(isPlayable: isPlayable, dominoes: dominoes)
}

func createTrain(isPlayable: Bool = false, domino: PlayedDomino) -> Train {
    createTrain(isPlayable: isPlayable, dominoes: [domino])
}

func createPlayer(id: String, dominoes: [UnplayedDomino], train: [PlayedDomino] = [], isPlayable: Bool = false) -> PlayerData {
    let train = createTrain(isPlayable: isPlayable, dominoes: train)
    return PlayerData(id: id, dominoes: dominoes, train: train, currentTurn: [])
}

func createPlayer(id: String, domino: UnplayedDomino, train: [PlayedDomino] = [], isPlayable: Bool = false) -> PlayerData {
    createPlayer(id: id, dominoes: [domino], train: train, isPlayable: isPlayable)
}
