//
//  StandardRuleSet.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class StandardRuleSet: RuleSet {
    func currentPlayerHasValidPlay(in game: Game) -> Bool {
        guard let currentPlayer = game.currentPlayer else {
            return false
        }

        let playerDominoes = currentPlayer.dominoes
        if currentPlayer.train.isStarted {
            let playableDominoes = game.playableDominoes
            return !playerDominoes
                .filter { $0.isPlayable(with: playableDominoes) }
                .isEmpty
        } else {
            let stationValue = game.stationValue
            return !playerDominoes
                .filter { $0.has(value: stationValue) }
                .isEmpty
        }
    }

    func player(_ player: Player, canPlay domino: Domino, on train: [Domino], in game: Game) -> Bool {
        return true
    }
}

private extension Game {
    var playableDominoes: [Domino] {
        return playableTrains
            .compactMap { $0.dominoes.last }
    }

    var playableTrains: [Train] {
        guard let currentPlayer = currentPlayer else {
            return []
        }

        return [mexicanTrain, currentPlayer.train] +
            otherPlayers.map { $0.train }
            .filter { $0.isPlayable }
    }
}
