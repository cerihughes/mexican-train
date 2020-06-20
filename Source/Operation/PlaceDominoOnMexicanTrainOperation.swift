//
//  PlaceDominoOnMexicanTrainOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnMexicanTrainOperation {
    func perform(game: Game, domino: UnplayedDomino) -> GameData? {
        if let gate = game.gameData.firstOpenGate {
            return performOpenGate(game: game, domino: domino, gate: gate)
        } else {
            return performNoOpenGate(game: game, domino: domino)
        }
    }

    private func performOpenGate(game: Game, domino: UnplayedDomino, gate: DominoValue) -> GameData? {
        guard let lastTrainDomino = game.gameData.mexicanTrain.dominoes.last,
            lastTrainDomino.isDouble(gate),
            let update = performNoOpenGate(game: game, domino: domino) else {
            return nil
        }

        var openGates = game.gameData.openGates
        openGates.remove(at: 0)
        return update.with(openGates: openGates)
    }

    private func performNoOpenGate(game: Game, domino: UnplayedDomino) -> GameData? {
        guard let currentPlayer = game.currentLocalPlayer,
            currentPlayer.canPlayOn(train: game.gameData.mexicanTrain),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let trainValue = game.gameData.mexicanTrain.playableValue ?? game.gameData.stationValue
        guard let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = game.gameData.mexicanTrain.with(domino: playedDomino)
        var openGates = game.gameData.openGates
        if domino.isDouble {
            openGates.append(domino.value1)
        }
        return game.gameData.with(updatedPlayer: updatedCurrentPlayer, mexicanTrain: updatedTrain, openGates: openGates)
    }
}
