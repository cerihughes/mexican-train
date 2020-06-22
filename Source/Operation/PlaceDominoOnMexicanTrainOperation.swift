//
//  PlaceDominoOnMexicanTrainOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnMexicanTrainOperation {
    func perform(currentPlayer: Player, game: Game, domino: UnplayedDomino) -> Game? {
        if let gate = game.gateThatMustBeClosed {
            return performOpenGate(currentPlayer: currentPlayer, game: game, domino: domino, gate: gate)
        } else {
            return performNoOpenGate(currentPlayer: currentPlayer, game: game, domino: domino)
        }
    }

    private func performOpenGate(currentPlayer: Player, game: Game, domino: UnplayedDomino, gate: DominoValue) -> Game? {
        guard let lastTrainDomino = game.mexicanTrain.dominoes.last,
            lastTrainDomino.isDouble(gate),
            let update = performNoOpenGate(currentPlayer: currentPlayer, game: game, domino: domino) else {
            return nil
        }

        var openGates = game.openGates
        openGates.removeAll(where: { $0 == gate })
        return update.with(openGates: openGates)
    }

    private func performNoOpenGate(currentPlayer: Player, game: Game, domino: UnplayedDomino) -> Game? {
        guard currentPlayer.canPlayOn(train: game.mexicanTrain),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let trainValue = game.mexicanTrain.playableValue ?? game.stationValue
        guard let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = game.mexicanTrain.with(domino: playedDomino)
        var openGates = game.openGates
        if domino.isDouble {
            openGates.append(domino.value1)
        }
        return game.with(updatedPlayer: updatedCurrentPlayer, mexicanTrain: updatedTrain, openGates: openGates)
    }
}
