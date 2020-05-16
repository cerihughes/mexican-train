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
    let train1 = Train(playable: false, dominoes: [])
    let train2 = Train(playable: false, dominoes: [])
    let mexicanTrain = Train(playable: true, dominoes: [])
    let player1 = Player(id: 1, name: "Player1", dominoes: hand1, train: train1)
    let player2 = Player(id: 2, name: "Player2", dominoes: hand2, train:train2)
    return Game(stationValue: .zero, currentPlayerId: 1, initialPlayerId: 1, mexicanTrain: mexicanTrain, players: [player1, player2], pool: pool)
}
