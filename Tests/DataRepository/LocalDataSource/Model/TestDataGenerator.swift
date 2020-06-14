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
                playerDominoes: [UnplayedDomino],
                playerTrain: [PlayedDomino] = [],
                mexicanTrain: [PlayedDomino] = [],
                pool: [UnplayedDomino] = []) -> GameData {
    let player = createPlayer(dominoes: playerDominoes, train: playerTrain)
    return createGame(stationValue: stationValue, players: [player], mexicanTrain: mexicanTrain, pool: pool)
}

func createTrain(isPlayable: Bool = false, dominoes: [PlayedDomino] = []) -> Train {
    Train(isPlayable: isPlayable, dominoes: dominoes)
}

func createTrain(isPlayable: Bool = false, domino: PlayedDomino) -> Train {
    createTrain(isPlayable: isPlayable, dominoes: [domino])
}

func createPlayerDetails(id: String = "P1", name: String? = nil) -> PlayerData.Details {
    PlayerData.Details(id: id, name: name ?? "Player_" + id)
}

func createPlayer(id: String = "P1", name: String? = nil, dominoes: [UnplayedDomino], train: [PlayedDomino] = [], isPlayable: Bool = false) -> PlayerData {
    let train = createTrain(isPlayable: isPlayable, dominoes: train)
    let details = createPlayerDetails(id: id, name: name)
    return PlayerData(details: details, dominoes: dominoes, train: train)
}

func createPlayer(id: String = "P1", name: String? = nil, domino: UnplayedDomino, train: [PlayedDomino] = [], isPlayable: Bool = false) -> PlayerData {
    createPlayer(id: id, name: name, dominoes: [domino], train: train, isPlayable: isPlayable)
}

extension GameData {
    func createInitialState() -> Game {
        Game(gameData: self, currentPlayerId: players[0].details.id)
    }
}

extension Game {
    func incrementedState(gameData: GameData) -> Game {
        let currentIndex = gameData.players.firstIndex(where: { $0.details.id == currentPlayerId })!
        let nextPlayer = gameData.players[safe: currentIndex + 1] ?? gameData.players.first!

        return Game(gameData: gameData, currentPlayerId: nextPlayer.details.id)
    }
}
