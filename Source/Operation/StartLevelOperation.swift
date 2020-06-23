//
//  StartLevelOperation.swift
//  MexicanTrain
//
//  Created by Home on 22/06/2020.
//

import Foundation

class StartLevelOperation {
    private let shuffler: Shuffler

    init(shuffler: Shuffler) {
        self.shuffler = shuffler
    }

    func perform(game: Game, stationValue: DominoValue) -> GameData? {
        guard let currentPlayer = game.currentLocalPlayer,
            currentPlayer.dominoes.isEmpty,
            currentPlayer.train.isStarted == false else {
            return nil
        }

        let mexicanTrain = Train(isPlayable: true, dominoes: [])
        var pool = game.gameData.pool
        let dominoes = pool.removeRandomElements(15, using: shuffler)
        let updatedPlayer = currentPlayer.with(dominoes: dominoes)
        return game.gameData.with(stationValue: stationValue, mexicanTrain: mexicanTrain, updatedPlayer: updatedPlayer)
    }
}
