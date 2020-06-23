//
//  ChangeTrainPlayableStateOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class ChangeTrainPlayableStateOperation: Operation {
    func perform(game: Game) -> Game? {
        guard let currentPlayer = currentLocalPlayer(game: game) else { return nil }
        let train = currentPlayer.train
        let updatedTrain = currentPlayer.train.with(isPlayable: !train.isPlayable)
        let updatedPlayer = currentPlayer.with(train: updatedTrain)
        return game.with(updatedPlayer: updatedPlayer)
    }
}
