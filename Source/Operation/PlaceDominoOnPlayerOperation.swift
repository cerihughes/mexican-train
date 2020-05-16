//
//  PlaceDominoOnPlayerOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnPlayerOperation {
    private let ruleSet: RuleSet
    private let domino: Domino
    private let player: Player

    init(ruleSet: RuleSet, domino: Domino, player: Player) {
        self.ruleSet = ruleSet
        self.domino = domino
        self.player = player
    }

    func perform(game: Game) -> Game? {
        guard let currentPlayer = game.currentPlayer,
            ruleSet.player(currentPlayer, canPlay: domino, on: player.train.dominoes, in: game),
            var updatedPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let updatedTrain = player.train.with(domino: domino)
        updatedPlayer = updatedPlayer.with(train: updatedTrain)
        return game.with(updatedPlayer: updatedPlayer)
            .withIncrementedPlayer()
    }
}
