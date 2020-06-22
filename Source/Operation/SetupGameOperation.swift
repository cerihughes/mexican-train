//
//  SetupGameOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import UIKit

class SetupGameOperation: Operation {
    private let shuffler: Shuffler

    init(gameEngine: GameEngine, shuffler: Shuffler) {
        self.shuffler = shuffler
        super.init(gameEngine: gameEngine)
    }

    func perform(stationValue: DominoValue = .twelve) -> Game? {
        guard let localPlayerId = gameEngine.engineState?.localPlayerId else { return nil }
        let mexicanTrain = Train(isPlayable: true, dominoes: [])
        var pool = UnplayedDomino.allDominoes(except: stationValue)
        let player = Player(id: localPlayerId,
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
