//
//  Model+Extensions.swift
//  MexicanTrain
//
//  Created by Home on 26/06/2020.
//

import Foundation

extension Game {
    var isLevelFinished: Bool {
        players.anySatisfies { $0.hasPlayedAllDominoes }
    }

    var isPlayingLevel: Bool {
        !isLevelFinished && players.count > 1 && players.allSatisfy { $0.isPlayingLevel }
    }

    var gateThatMustBeClosed: DominoValue? {
        if hasAnyPlayerPlayedDoubleInThisTurn {
            return nil
        }
        return openGates.first
    }

    var hasAnyPlayerPlayedDoubleInThisTurn: Bool {
        !players.allSatisfy { !$0.hasPlayedDoubleInThisTurn }
    }

    func player(id: String) -> Player? {
        players.filter { $0.id == id }
            .first
    }

    func playerHasValidPlay(player: Player) -> Bool {
        if let openGate = gateThatMustBeClosed {
            return player.hasMatchingDominoFor(value: openGate)
        }

        let playerDominoes = player.dominoes
        if player.train.isStarted {
            return !playerDominoes
                .filter { $0.isPlayable(with: playableTrainValues(player: player)) }
                .isEmpty
        } else {
            return player.hasMatchingDominoFor(value: stationValue)
        }
    }

    func playableTrainValues(player: Player) -> [DominoValue] {
        playableTrains(player: player)
            .compactMap { $0.dominoes.last?.outerValue }
    }

    func playableTrains(player: Player) -> [Train] {
        return [mexicanTrain, player.train] +
            otherPlayers(player: player).map { $0.train }
            .filter { $0.isPlayable }
    }

    private func otherPlayers(player: Player) -> [Player] {
        players.removing(player)
    }
}

extension Player {
    var isPlayingLevel: Bool {
        !dominoes.isEmpty
    }

    var hasPlayedAllDominoes: Bool {
        dominoes.isEmpty && train.isStarted
    }

    var pointsValue: Int {
        dominoes.map { $0.pointsValue }
            .reduce(0, +)
    }

    var hasPlayedDoubleInThisTurn: Bool {
        !currentTurn.isEmpty
    }

    func hasMatchingDominoFor(value: DominoValue) -> Bool {
        return !dominoes
            .filter { $0.has(value: value) }
            .isEmpty
    }

    func canPlayOn(train: Train) -> Bool {
        if self.train == train {
            return true
        }

        guard self.train.isStarted else {
            return false
        }

        if let last = train.dominoes.last, last.isDouble {
            return true
        }

        return train.isPlayable
    }
}

extension UnplayedDomino {
    var pointsValue: Int {
        value1.rawValue + value2.rawValue
    }

    func playedDomino(on value: DominoValue) -> PlayedDomino? {
        guard has(value: value) else {
            return nil
        }

        if value1 == value {
            return PlayedDomino(innerValue: value1, outerValue: value2)
        } else {
            return PlayedDomino(innerValue: value2, outerValue: value1)
        }
    }

    func isPlayable(with oneOf: [DominoValue]) -> Bool {
        !oneOf.filter { has(value: $0) }
            .isEmpty
    }
}

extension DominoValue {
    var nextValue: DominoValue? {
        DominoValue(rawValue: rawValue - 1)
    }
}
