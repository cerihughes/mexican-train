//
//  PlaceDominoOnMexicanTrainOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnMexicanTrainOperation: Operation {
    func perform(game: Game, domino: UnplayedDomino) -> Game? {
        guard let currentPlayer = currentLocalPlayer(game: game) else { return nil }
        if let gate = game.gateThatMustBeClosed {
            return performOpenGate(currentPlayer: currentPlayer, game: game, domino: domino, gate: gate)
        } else {
            return performNoOpenGate(currentPlayer: currentPlayer, game: game, domino: domino)
        }
    }

    private func performOpenGate(currentPlayer: Player, game: Game, domino: UnplayedDomino, gate: DominoValue) -> Game? {
        guard let lastTrainDomino = game.mexicanTrain.dominoes.last,
            lastTrainDomino.isDouble(gate) else {
            return nil
        }

        return performNoOpenGate(currentPlayer: currentPlayer, game: game, domino: domino)
    }

    private func performNoOpenGate(currentPlayer: Player, game: Game, domino: UnplayedDomino) -> Game? {
        guard currentPlayer.canPlayOn(train: game.mexicanTrain),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let lastPlayedDomino = game.mexicanTrain.dominoes.last
        let trainValue = game.mexicanTrain.playableValue ?? game.stationValue
        guard let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = game.mexicanTrain.with(domino: playedDomino)
        var openGates = game.openGates
        if let lastPlayedDomino = lastPlayedDomino, lastPlayedDomino.isDouble {
            openGates.removeAll(where: { $0 == lastPlayedDomino.innerValue })
        } else if domino.isDouble {
            openGates.append(domino.value1)
        }
        return game.with(mexicanTrain: updatedTrain, updatedPlayer: updatedCurrentPlayer, openGates: openGates)
    }
}
