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

    func perform(stationValue: DominoValue = .twelve, playerNames: [String]) -> Game {
        let mexicanTrain = Train(isPlayable: true, dominoes: [])
        var pool = UnplayedDomino.allDominoes(except: stationValue)
        let players = playerNames.enumerated()
            .map { Player(id: $0.offset + 1,
                          name: $0.element,
                          dominoes: pool.removeRandomElements(15, using: shuffler),
                          train: Train(isPlayable: false, dominoes: [])) }
        return Game(stationValue: stationValue,
                    currentPlayerId: 1,
                    initialPlayerId: 1,
                    mexicanTrain: mexicanTrain,
                    players: players,
                    pool: pool)
    }
}
