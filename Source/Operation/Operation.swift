//
//  Operation.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Foundation

class Operation {
    let gameEngine: GameEngine

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }

    func currentLocalPlayer(game: Game) -> Player? {
        gameEngine.engineState.currentLocalPlayer(game: game)
    }
}

extension EngineState {
    func currentLocalPlayer(game: Game) -> Player? {
        guard localPlayerIsCurrentPlayer else { return nil }
        return localPlayer(game: game)
    }

    func localPlayer(game: Game) -> Player? {
        return game.player(id: localPlayerId)
    }
}

extension Game {
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
}

private extension Game {
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

private extension Player {
    func hasMatchingDominoFor(value: DominoValue) -> Bool {
        return !dominoes
            .filter { $0.has(value: value) }
            .isEmpty
    }
}
