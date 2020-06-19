//
//  GameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import UIKit

protocol GameViewModel {
    var totalPlayerCount: Int { get }

    var currentPlayerTurn: AnyPublisher<Bool, Never> { get }
    var playerDominoes: AnyPublisher<[DominoView.State], Never> { get }
    var mexicanTrain: AnyPublisher<[DominoView.State], Never> { get }
    var player1Train: AnyPublisher<[DominoView.State], Never> { get }
    var player2Train: AnyPublisher<[DominoView.State], Never> { get }
    var player3Train: AnyPublisher<[DominoView.State], Never> { get }
    var player4Train: AnyPublisher<[DominoView.State], Never> { get }

    func playDomino(at index: Int, completion: @escaping (Bool) -> Void)
    func pickup(completion: @escaping (Bool) -> Void)
}

extension GameViewModel {
    func train(for player: Int) -> AnyPublisher<[DominoView.State], Never>? {
        guard player < totalPlayerCount else { return nil }
        switch player {
        case 0: return player1Train
        case 1: return player2Train
        case 2: return player3Train
        case 3: return player4Train
        default: return nil
        }
    }
}

class GameViewModelImpl: GameViewModel {
    private let gameEngine: GameEngine
    private let ruleSet: RuleSet
    private let operations: Operations

    private var localPlayerId: String
    private var latestGame: Game = Game.createFakeGame()
    private var subscription: AnyCancellable?
    private var timer: Timer?

    let totalPlayerCount: Int
    let currentPlayerTurn: AnyPublisher<Bool, Never>
    let playerDominoes: AnyPublisher<[DominoView.State], Never>
    let mexicanTrain: AnyPublisher<[DominoView.State], Never>
    let player1Train: AnyPublisher<[DominoView.State], Never>
    let player2Train: AnyPublisher<[DominoView.State], Never>
    let player3Train: AnyPublisher<[DominoView.State], Never>
    let player4Train: AnyPublisher<[DominoView.State], Never>

    init(gameEngine: GameEngine, ruleSet: RuleSet, operations: Operations, totalPlayerCount: Int) {
        self.gameEngine = gameEngine
        self.ruleSet = ruleSet
        self.operations = operations
        self.totalPlayerCount = totalPlayerCount

        localPlayerId = gameEngine.localPlayerId

        let gameData = gameEngine.gamePublisher
            .map { $0.gameData }
        let player = gameEngine.gamePublisher
            .compactMap { $0.localPlayer }

        currentPlayerTurn = gameEngine.gamePublisher
            .map { $0.isCurrentPlayer }
            .eraseToAnyPublisher()

        playerDominoes = player
            .map { $0.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

        mexicanTrain = gameData
            .map { $0.mexicanTrain.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

        player1Train = gameData
            .playerTrain(at: 0)

        player2Train = gameData
            .playerTrain(at: 1)

        player3Train = gameData
            .playerTrain(at: 2)

        player4Train = gameData
            .playerTrain(at: 3)

        subscription = gameEngine.gamePublisher
            .assign(to: \.latestGame, on: self)

        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            gameEngine.refresh()
        }
    }

    func playDomino(at index: Int, completion: @escaping (Bool) -> Void) {
        guard let localPlayerData = latestGame.gameData.player(id: localPlayerId),
            let unplayedDomino = localPlayerData.dominoes[safe: index],
            let update = operations.playOnPlayer.perform(game: latestGame, domino: unplayedDomino, playerId: localPlayerData.id) else {
            completion(false)
            return
        }

        gameEngine.endTurn(gameData: update) { completion($0) }
    }

    func pickup(completion: @escaping (Bool) -> Void) {
        guard let update = operations.pickUp.perform(game: latestGame) else {
            completion(false)
            return
        }

        gameEngine.endTurn(gameData: update) { completion($0) }
    }
}

private extension Publishers.Map where Upstream == Published<Game>.Publisher, Output == GameData {
    func playerTrain(at index: Int) -> AnyPublisher<[DominoView.State], Never> {
        return compactMap { $0.players[safe: index] }
            .map { $0.train.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

private extension Publisher {
    func arrayMap<T, U>(_ transform: @escaping (T) -> U) -> Publishers.Map<Self, [U]> where Output == [T] {
        map { $0.map(transform) }
    }
}

private extension UnplayedDomino {
    var faceUpState: DominoView.State {
        .faceUp(value1.viewValue, value2.viewValue)
    }

    var faceDownState: DominoView.State {
        .faceDown
    }
}

private extension PlayedDomino {
    var faceUpState: DominoView.State {
        .faceUp(innerValue.viewValue, outerValue.viewValue)
    }
}

private extension DominoValue {
    var viewValue: DominoFaceView.Value {
        switch self {
        case .zero: return .zero
        case .one: return .one
        case .two: return .two
        case .three: return .three
        case .four: return .four
        case .five: return .five
        case .six: return .six
        case .seven: return .seven
        case .eight: return .eight
        case .nine: return .nine
        case .ten: return .ten
        case .eleven: return .eleven
        case .twelve: return .twelve
        }
    }
}
