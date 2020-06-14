//
//  PlaceDominoOnMexicanTrainOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnMexicanTrainOperation {
    private let ruleSet: RuleSet

    init(ruleSet: RuleSet) {
        self.ruleSet = ruleSet
    }

    func perform(game: Game, domino: UnplayedDomino) -> GameData? {
        guard let currentPlayer = game.currentPlayer,
            ruleSet.player(currentPlayer, canPlay: domino, on: game.gameData.mexicanTrain, in: game),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino),
            let trainValue = game.gameData.mexicanTrain.playableValue,
            let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = game.gameData.mexicanTrain.with(domino: playedDomino)
        return game.gameData.with(updatedPlayer: updatedCurrentPlayer, mexicanTrain: updatedTrain)
    }
}
