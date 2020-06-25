//
//  StartLevelOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Foundation

class StartLevelOperation: Operation {
    private let shuffler: Shuffler

    init(gameEngine: GameEngine, shuffler: Shuffler) {
        self.shuffler = shuffler
        super.init(gameEngine: gameEngine)
    }

    func perform(game: Game, stationValue: DominoValue) -> Game {
        let mexicanTrain = Train(isPlayable: true, dominoes: [])
        var pool = UnplayedDomino.allDominoes(except: stationValue)
        let updatedPlayers = game.players.map { $0.with(dominoes: pool.removeRandomElements(15, using: shuffler),
                                                        train: Train(isPlayable: false, dominoes: []),
                                                        currentTurn: []) }
        return game.with(stationValue: stationValue, mexicanTrain: mexicanTrain, players: updatedPlayers, pool: pool)
    }
}
