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

    func perform(gameState: GameState) -> Game? {
        guard let currentPlayer = gameState.currentPlayer,
            ruleSet.player(currentPlayer, canPlay: domino, on: gameState.game.mexicanTrain, in: gameState),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino),
            let trainValue = gameState.game.mexicanTrain.playableValue,
            let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = gameState.game.mexicanTrain.with(domino: playedDomino)
        return gameState.game.with(updatedPlayer: updatedCurrentPlayer, mexicanTrain: updatedTrain)
    }
}
