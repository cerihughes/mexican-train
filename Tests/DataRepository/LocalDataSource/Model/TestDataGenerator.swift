//
//  TestDataGenerator.swift
//  Tests
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

@testable import MexicanTrain

func createGame(stationValue: DominoValue = .zero,
                players: [PlayerData],
                mexicanTrain: [PlayedDomino] = [],
                pool: [UnplayedDomino] = []) -> GameData {
    let mexicanTrain = Train(isPlayable: true, dominoes: mexicanTrain)
    return GameData(stationValue: stationValue,
                    mexicanTrain: mexicanTrain,
                    players: players,
                    pool: pool)
}

func createGame(stationValue: DominoValue = .zero,
                playerId: String,
                playerDominoes: [UnplayedDomino],
                playerTrain: [PlayedDomino] = [],
                mexicanTrain: [PlayedDomino] = [],
                pool: [UnplayedDomino] = []) -> GameData {
    let player = createPlayer(id: playerId, dominoes: playerDominoes, train: playerTrain)
    return createGame(stationValue: stationValue, players: [player], mexicanTrain: mexicanTrain, pool: pool)
}

func createTrain(isPlayable: Bool = false, dominoes: [PlayedDomino] = []) -> Train {
    Train(isPlayable: isPlayable, dominoes: dominoes)
}

func createTrain(isPlayable: Bool = false, domino: PlayedDomino) -> Train {
    createTrain(isPlayable: isPlayable, dominoes: [domino])
}

func createPlayer(id: String, dominoes: [UnplayedDomino], train: [PlayedDomino] = [], isPlayable: Bool = false) -> PlayerData {
    let train = createTrain(isPlayable: isPlayable, dominoes: train)
    return PlayerData(id: id, dominoes: dominoes, train: train)
}

func createPlayer(id: String, domino: UnplayedDomino, train: [PlayedDomino] = [], isPlayable: Bool = false) -> PlayerData {
    createPlayer(id: id, dominoes: [domino], train: train, isPlayable: isPlayable)
}

extension GameData {
    var generatedPlayerDetails: [PlayerDetails] {
        players.map { $0.id }
            .map { PlayerDetails(id: $0, name: "Player_\($0)") }
    }

    func createInitialState(totalPlayerCount: Int = 4, localPlayerId: String) -> Game {
        let playerDetails = generatedPlayerDetails
        return Game(gameData: self,
                    totalPlayerCount: totalPlayerCount,
                    playerDetails: playerDetails,
                    localPlayerId: localPlayerId,
                    currentPlayerId: localPlayerId)
    }
}

extension Game {
    func incrementedState(gameData: GameData) -> Game {
        let currentIndex = gameData.players.firstIndex(where: { $0.id == currentPlayerId })!
        let nextPlayer = gameData.players[safe: currentIndex + 1] ?? gameData.players.first!

        return Game(gameData: gameData,
                    totalPlayerCount: totalPlayerCount,
                    playerDetails: gameData.generatedPlayerDetails,
                    localPlayerId: localPlayerId,
                    currentPlayerId: nextPlayer.id)
    }
}
