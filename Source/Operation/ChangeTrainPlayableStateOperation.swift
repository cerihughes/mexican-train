//
//  ChangeTrainPlayableStateOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class ChangeTrainPlayableStateOperation {
    func perform(game: GameTurn) -> Game? {
        guard let currentPlayer = game.currentLocalPlayer else {
            return nil
        }

        let train = currentPlayer.train
        let updatedTrain = currentPlayer.train.with(isPlayable: !train.isPlayable)
        let updatedPlayer = currentPlayer.with(train: updatedTrain)
        return game.gameData.with(updatedPlayer: updatedPlayer)
    }
}
