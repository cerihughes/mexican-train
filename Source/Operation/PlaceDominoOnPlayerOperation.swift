//
//  PlaceDominoOnPlayerOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnPlayerOperation {
    private let ruleSet: RuleSet
    private let domino: UnplayedDomino
    private let playerId: String

    init(ruleSet: RuleSet, domino: UnplayedDomino, playerId: String) {
        self.ruleSet = ruleSet
        self.domino = domino
        self.playerId = playerId
    }

    func perform(game: Game) -> Game? {
        guard let currentPlayer = game.currentPlayer,
            let player = game.player(id: playerId),
            ruleSet.player(currentPlayer, canPlay: domino, on: player.train, in: game),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let updatedGame = game.with(updatedPlayer: updatedCurrentPlayer)
        guard let refreshedPlayer = updatedGame.player(id: playerId),
            let trainValue = refreshedPlayer.train.playableValue,
            let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = refreshedPlayer.train.with(domino: playedDomino)
        let updatedPlayer = refreshedPlayer.with(train: updatedTrain)
        return updatedGame.with(updatedPlayer: updatedPlayer)
            .withIncrementedPlayer()
    }
}
