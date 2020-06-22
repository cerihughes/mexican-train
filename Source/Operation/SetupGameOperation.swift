//
//  SetupGameOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import UIKit

class SetupGameOperation {
    private let shuffler: Shuffler

    init(shuffler: Shuffler) {
        self.shuffler = shuffler
    }

    func perform(stationValue: DominoValue = .twelve, playerId: String) -> Game {
        let mexicanTrain = Train(isPlayable: true, dominoes: [])
        var pool = UnplayedDomino.allDominoes(except: stationValue)
        let player = Player(id: playerId,
                                dominoes: pool.removeRandomElements(15, using: shuffler),
                                train: Train(isPlayable: false, dominoes: []),
                                currentTurn: [],
                                score: 0)
        return Game(stationValue: stationValue,
                        mexicanTrain: mexicanTrain,
                        players: [player],
                        pool: pool,
                        openGates: [])
    }
}
