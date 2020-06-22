//
//  PlaceDominoOnPlayerOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PlaceDominoOnPlayerOperation {
    func perform(currentPlayer: Player, game: Game, domino: UnplayedDomino, playerId: String) -> Game? {
        if let gate = game.gateThatMustBeClosed {
            return performOpenGate(currentPlayer: currentPlayer, game: game, domino: domino, playerId: playerId, gate: gate)
        } else {
            return performNoOpenGate(currentPlayer: currentPlayer, game: game, domino: domino, playerId: playerId)
        }
    }

    private func performOpenGate(currentPlayer: Player, game: Game, domino: UnplayedDomino, playerId: String, gate: DominoValue) -> Game? {
        guard let playerTrain = game.player(id: playerId)?.train,
            let lastTrainDomino = playerTrain.dominoes.last,
            lastTrainDomino.isDouble(gate),
            let update = performNoOpenGate(currentPlayer: currentPlayer, game: game, domino: domino, playerId: playerId) else {
            return nil
        }

        var openGates = game.openGates
        openGates.removeAll(where: { $0 == gate })
        return update.with(openGates: openGates)
    }

    private func performNoOpenGate(currentPlayer: Player, game: Game, domino: UnplayedDomino, playerId: String) -> Game? {
        guard let player = game.player(id: playerId),
            currentPlayer.canPlayOn(train: player.train),
            let updatedCurrentPlayer = currentPlayer.without(domino: domino) else {
            return nil
        }

        let updatedGame = game.with(updatedPlayer: updatedCurrentPlayer)
        guard let refreshedPlayer = updatedGame.player(id: playerId) else {
            return nil
        }

        let trainValue = refreshedPlayer.train.playableValue ?? game.stationValue
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
