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

    func perform(stationValue: DominoValue = .twelve, playerDetails: [Player.Details], initialPlayerId: String) -> Game {
        let mexicanTrain = Train(isPlayable: true, dominoes: [])
        var pool = UnplayedDomino.allDominoes(except: stationValue)
        let players = playerDetails
            .map { Player(details: $0,
                          dominoes: pool.removeRandomElements(15, using: shuffler),
                          train: Train(isPlayable: false, dominoes: [])) }
        return Game(stationValue: stationValue,
                    currentPlayerId: initialPlayerId,
                    initialPlayerId: initialPlayerId,
                    mexicanTrain: mexicanTrain,
                    players: players,
                    pool: pool)
    }
}
