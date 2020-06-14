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

    func perform(game: Game, domino: UnplayedDomino, playerId: String) -> GameData? {
        guard let currentPlayer = game.currentLocalPlayer,
            let player = game.gameData.player(id: playerId),
            ruleSet.player(currentPlayer, canPlay: domino, on: player.train, in: game),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let updatedGame = game.gameData.with(updatedPlayer: updatedCurrentPlayer)
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
