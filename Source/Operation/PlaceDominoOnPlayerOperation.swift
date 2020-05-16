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
    private let playerId: Int

    init(ruleSet: RuleSet, domino: Domino, playerId: Int) {
        self.ruleSet = ruleSet
        self.domino = domino
        self.playerId = playerId
    }

    func perform(game: Game) -> Game? {
        guard let currentPlayer = game.currentPlayer,
            let player = game.player(id: playerId),
            ruleSet.player(currentPlayer, canPlay: domino, on: player.train.dominoes, in: game),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let updatedGame = game.with(updatedPlayer: updatedCurrentPlayer)
        guard let refreshedPlayer = updatedGame.player(id: playerId) else {
            return nil
        }

        let updatedTrain = refreshedPlayer.train.with(domino: domino)
        let updatedPlayer = refreshedPlayer.with(train: updatedTrain)
        return updatedGame.with(updatedPlayer: updatedPlayer)
            .withIncrementedPlayer()
    }
}