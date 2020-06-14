//
//  ChangeTrainPlayableStateOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class ChangeTrainPlayableStateOperation {
    func perform(gameState: GameState) -> GameData? {
        guard let currentPlayer = gameState.currentPlayer else {
            return nil
        }

        let train = currentPlayer.train
        let updatedTrain = currentPlayer.train.with(isPlayable: !train.isPlayable)
        let updatedPlayer = currentPlayer.with(train: updatedTrain)
        return gameState.game.with(updatedPlayer: updatedPlayer)
    }
}
