//
//  PlaceDominoOnMexicanTrainOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnMexicanTrainOperation {
    func perform(game: Game, domino: UnplayedDomino) -> GameData? {
        guard let currentPlayer = game.currentLocalPlayer,
            currentPlayer.canPlayOn(train: game.gameData.mexicanTrain),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let trainValue = game.gameData.mexicanTrain.playableValue ?? game.gameData.stationValue
        guard let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = game.gameData.mexicanTrain.with(domino: playedDomino)
        return game.gameData.with(updatedPlayer: updatedCurrentPlayer, mexicanTrain: updatedTrain)
    }
}
