//
//  PlaceDominoOnPlayerOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnPlayerOperation {
    private let ruleSet: RuleSet

    init(ruleSet: RuleSet) {
        self.ruleSet = ruleSet
    }

    func perform(gameState: GameState, domino: UnplayedDomino, playerId: String) -> GameData? {
        guard let currentPlayer = gameState.currentPlayer,
            let player = gameState.game.player(id: playerId),
            ruleSet.player(currentPlayer, canPlay: domino, on: player.train, in: gameState),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let updatedGame = gameState.game.with(updatedPlayer: updatedCurrentPlayer)
        guard let refreshedPlayer = updatedGame.player(id: playerId),
            let trainValue = refreshedPlayer.train.playableValue,
            let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = refreshedPlayer.train.with(domino: playedDomino)
        let updatedPlayer = refreshedPlayer.with(train: updatedTrain)
        return updatedGame.with(updatedPlayer: updatedPlayer)
    }
}
