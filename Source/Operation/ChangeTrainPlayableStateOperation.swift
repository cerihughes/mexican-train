//
//  ChangeTrainPlayableStateOperation.swift
//  MexicanTrain
//
//  Created by Home on 16/05/2020.
//

import UIKit

class ChangeTrainPlayableStateOperation {
    func perform(game: Game) -> Game? {
        guard let currentPlayer = game.currentPlayer else {
            return nil
        }

        let train = currentPlayer.train
        let updatedTrain = currentPlayer.train.with(isPlayable: !train.isPlayable)
        let updatedPlayer = currentPlayer.with(train: updatedTrain)
        return game.with(updatedPlayer: updatedPlayer)
    }
}
