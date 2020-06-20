//
//  PlaceDominoOnPlayerOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnPlayerOperation {
    func perform(game: Game, domino: UnplayedDomino, playerId: String) -> GameData? {
        if let gate = game.gameData.gateThatMustBeClosed {
            return performOpenGate(game: game, domino: domino, playerId: playerId, gate: gate)
        } else {
            return performNoOpenGate(game: game, domino: domino, playerId: playerId)
        }
    }

    private func performOpenGate(game: Game, domino: UnplayedDomino, playerId: String, gate: DominoValue) -> GameData? {
        guard let playerTrain = game.gameData.player(id: playerId)?.train,
            let lastTrainDomino = playerTrain.dominoes.last,
            lastTrainDomino.isDouble(gate),
            let update = performNoOpenGate(game: game, domino: domino, playerId: playerId) else {
            return nil
        }

        var openGates = game.gameData.openGates
        openGates.removeAll(where: { $0 == gate })
        return update.with(openGates: openGates)
    }

    private func performNoOpenGate(game: Game, domino: UnplayedDomino, playerId: String) -> GameData? {
        guard let currentPlayer = game.currentLocalPlayer,
            let player = game.gameData.player(id: playerId),
            currentPlayer.canPlayOn(train: player.train),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let updatedGame = game.gameData.with(updatedPlayer: updatedCurrentPlayer)
        guard let refreshedPlayer = updatedGame.player(id: playerId) else {
            return nil
        }

        let trainValue = refreshedPlayer.train.playableValue ?? game.gameData.stationValue
        guard let playedDomino = domino.playedDomino(on: trainValue) else {
            return nil
        }

        let updatedTrain = refreshedPlayer.train.with(domino: playedDomino)
        let updatedPlayer = refreshedPlayer.with(train: updatedTrain)
        var openGates = updatedGame.openGates
        if domino.isDouble {
            openGates.append(domino.value1)
        }
        return updatedGame.with(updatedPlayer: updatedPlayer, openGates: openGates)
    }
}
