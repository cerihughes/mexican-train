//
//  StandardRuleSet.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class StandardRuleSet: RuleSet {
    func currentPlayerHasValidPlay(in gameState: GameState) -> Bool {
        guard let currentPlayer = gameState.currentPlayer else {
            return false
        }

        let playerDominoes = currentPlayer.dominoes
        if currentPlayer.train.isStarted {
            let playableTrainValues = gameState.playableTrainValues
            return !playerDominoes
                .filter { $0.isPlayable(with: playableTrainValues) }
                .isEmpty
        } else {
            let stationValue = gameState.game.stationValue
            return !playerDominoes
                .filter { $0.has(value: stationValue) }
                .isEmpty
        }
    }

    func player(_ player: PlayerData, canPlay domino: UnplayedDomino, on train: Train, in gameState: GameState) -> Bool {
        return true
    }
}

private extension GameState {
    var playableTrainValues: [DominoValue] {
        return playableTrains
            .compactMap { $0.dominoes.last?.outerValue }
    }

    var playableTrains: [Train] {
        guard let currentPlayer = currentPlayer else {
            return []
        }

        return [game.mexicanTrain, currentPlayer.train] +
            otherPlayers.map { $0.train }
            .filter { $0.isPlayable }
    }
}
