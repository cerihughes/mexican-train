//
//  StandardRuleSet.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class StandardRuleSet: RuleSet {
    func currentPlayerHasValidPlay(in game: Game) -> Bool {
        guard let currentPlayer = game.currentLocalPlayer else {
            return false
        }

        let playerDominoes = currentPlayer.dominoes
        if currentPlayer.train.isStarted {
            let playableTrainValues = game.playableTrainValues
            return !playerDominoes
                .filter { $0.isPlayable(with: playableTrainValues) }
                .isEmpty
        } else {
            let stationValue = game.gameData.stationValue
            return !playerDominoes
                .filter { $0.has(value: stationValue) }
                .isEmpty
        }
    }

    func player(_ player: PlayerData, canPlay domino: UnplayedDomino, on train: Train, in game: Game) -> Bool {
        return true
    }
}

private extension Game {
    var playableTrainValues: [DominoValue] {
        return playableTrains
            .compactMap { $0.dominoes.last?.outerValue }
    }

    var playableTrains: [Train] {
        guard let currentPlayer = currentLocalPlayer else {
            return []
        }

        return [gameData.mexicanTrain, currentPlayer.train] +
            otherPlayers.map { $0.train }
            .filter { $0.isPlayable }
    }
}
