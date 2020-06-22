//
//  GameTurn.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import Foundation

struct GameTurn {
    let gameData: Game
    let totalPlayerCount: Int
    let playerDetails: [PlayerDetails]
    let localPlayerId: String
    let isCurrentPlayer: Bool
}

extension GameTurn {
    var currentLocalPlayer: Player? {
        isCurrentPlayer ? localPlayer : nil
    }

    var localPlayer: Player? {
        gameData.player(id: localPlayerId)
    }

    var localPlayerIndex: Int? {
        playerDetails.firstIndex(where: { $0.id == localPlayerId })
    }

    var otherPlayers: [Player] {
        guard let localPlayer = localPlayer else {
            return gameData.players
        }

        return gameData.players.filter { $0.id != localPlayer.id }
    }

    var currentLocalPlayerHasValidPlay: Bool {
        guard let currentPlayer = currentLocalPlayer else {
            return false
        }

        if let openGate = gameData.gateThatMustBeClosed {
            return currentLocalPlayerHasValidPlayFor(double: openGate)
        }

        let playerDominoes = currentPlayer.dominoes
        if currentPlayer.train.isStarted {
            return !playerDominoes
                .filter { $0.isPlayable(with: playableTrainValues) }
                .isEmpty
        } else {
            let stationValue = gameData.stationValue
            return !playerDominoes
                .filter { $0.has(value: stationValue) }
                .isEmpty
        }
    }

    private func currentLocalPlayerHasValidPlayFor(double: DominoValue) -> Bool {
        guard let playerDominoes = currentLocalPlayer?.dominoes else {
            return false
        }

        return !playerDominoes
            .filter { $0.has(value: double) }
            .isEmpty
    }
}

extension GameTurn {
    static func createFakeGame() -> GameTurn {
        let initialGameData = Game(stationValue: .twelve, mexicanTrain: Train(isPlayable: true, dominoes: []), players: [], pool: [], openGates: [])
        return GameTurn(gameData: initialGameData, totalPlayerCount: 0, playerDetails: [], localPlayerId: "", isCurrentPlayer: false)
    }
}

private extension GameTurn {
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
