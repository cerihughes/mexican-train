//
//  TestDataGenerator.swift
//  Tests
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

@testable import MexicanTrain

func createTestGameData() -> Game {
    let shuffler = MockShuffler()
    var pool = Domino.allDominoes()
    let hand1 = pool.removeRandomElements(4, using: shuffler)
    let hand2 = pool.removeRandomElements(4, using: shuffler)
    let train1 = Train(isPlayable: false, dominoes: [])
    let train2 = Train(isPlayable: false, dominoes: [])
    let mexicanTrain = Train(isPlayable: true, dominoes: [])
    let player1 = Player(id: 1, name: "Player1", dominoes: hand1, train: train1)
    let player2 = Player(id: 2, name: "Player2", dominoes: hand2, train:train2)
    return Game(stationValue: .zero, currentPlayerId: 1, initialPlayerId: 1, mexicanTrain: mexicanTrain, players: [player1, player2], pool: pool)
}

func createGame(stationValue: Domino.Value = .zero,
                players: [Player],
                mexicanTrain: [Domino] = []) -> Game {
    let mexicanTrain = Train(isPlayable: true, dominoes: mexicanTrain)
    return Game(stationValue: stationValue, currentPlayerId: 1, initialPlayerId: 1, mexicanTrain: mexicanTrain, players: players, pool: [])
}

func createGame(stationValue: Domino.Value = .zero,
                playerDominoes: [Domino],
                playerTrain: [Domino] = [],
                mexicanTrain: [Domino] = []) -> Game {
    let player = createPlayer(dominoes: playerDominoes, train: createTrain(dominoes: playerTrain))
    return createGame(stationValue: stationValue, players: [player], mexicanTrain: mexicanTrain)
}

func createTrain(isPlayable: Bool = false, dominoes: [Domino] = []) -> Train {
    Train(isPlayable: isPlayable, dominoes: dominoes)
}

func createTrain(isPlayable: Bool = false, domino: Domino) -> Train {
    createTrain(isPlayable: isPlayable, dominoes: [domino])
}

func createPlayer(id: Int = 1, name: String = "Player", dominoes: [Domino], train: Train) -> Player {
    Player(id: id, name: name, dominoes: dominoes, train: train)
}

func createPlayer(id: Int = 1, name: String = "Player", domino: Domino, train: Train) -> Player {
    createPlayer(id: id, name: name, dominoes: [domino], train: train)
}
