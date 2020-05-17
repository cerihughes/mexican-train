//
//  PlaceDominoOnMexicanTrainOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnMexicanTrainOperation {
    private let ruleSet: RuleSet
    private let domino: UnplayedDomino

    init(ruleSet: RuleSet, domino: UnplayedDomino) {
        self.ruleSet = ruleSet
        self.domino = domino
    }

    func perform(game: Game) -> Game? {
        guard let currentPlayer = game.currentPlayer,
            ruleSet.player(currentPlayer, canPlay: domino, on: game.mexicanTrain, in: game),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino),
            let trainValue = game.mexicanTrain.playableValue,
            let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = game.mexicanTrain.with(domino: playedDomino)
        return game.with(updatedPlayer: updatedCurrentPlayer, mexicanTrain: updatedTrain)
            .withIncrementedPlayer()
    }
}
