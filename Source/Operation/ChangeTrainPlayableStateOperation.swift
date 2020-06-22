//
//  ChangeTrainPlayableStateOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class ChangeTrainPlayableStateOperation {
    func perform(currentPlayer: Player, game: Game) -> Game {
        let train = currentPlayer.train
        let updatedTrain = currentPlayer.train.with(isPlayable: !train.isPlayable)
        let updatedPlayer = currentPlayer.with(train: updatedTrain)
        return game.with(updatedPlayer: updatedPlayer)
    }
}
