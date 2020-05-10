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
    let player1 = Player(id: 1, name: "Player1", dominoes: hand1, train: [])
    let player2 = Player(id: 2, name: "Player2", dominoes: hand2, train: [])
    return Game(stationValue: .zero, currentPlayerId: 1, initialPlayerId: 1, mexicanTrain: [], players: [player1, player2], pool: pool)
}
