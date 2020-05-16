//
//  PlaceDominoOnMexicanTrainOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnMexicanTrainOperation {
    private let ruleSet: RuleSet
    private let domino: Domino

    init(ruleSet: RuleSet, domino: Domino) {
        self.ruleSet = ruleSet
        self.domino = domino
    }

    func perform(game: Game) -> Game? {
        guard let currentPlayer = game.currentPlayer,
            ruleSet.player(currentPlayer, canPlay: domino, on: game.mexicanTrain.dominoes, in: game),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let updatedTrain = game.mexicanTrain.with(domino: domino)
        return game.with(updatedPlayer: updatedCurrentPlayer, mexicanTrain: updatedTrain)
            .withIncrementedPlayer()
    }
}
