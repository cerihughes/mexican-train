//
//  GameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import UIKit

protocol GameViewModel {
    var playerDominoes: AnyPublisher<[DominoView.State], Never> { get }
    var mexicanTrain: AnyPublisher<[DominoView.State], Never> { get }
    var player1Train: AnyPublisher<[DominoView.State], Never> { get }
    var player2Train: AnyPublisher<[DominoView.State], Never> { get }

    func playDomino(at index: Int, completion: @escaping (Bool) -> Void)
}

class GameViewModelImpl: GameViewModel {
    private let gameEngine: GameEngine
    private let ruleSet: RuleSet
    private let operations: Operations

    private var localPlayerId: String
    private var latestGame: Game = Game.createFakeGame()
    private var subscription: AnyCancellable?

    let playerDominoes: AnyPublisher<[DominoView.State], Never>
    let mexicanTrain: AnyPublisher<[DominoView.State], Never>
    let player1Train: AnyPublisher<[DominoView.State], Never>
    let player2Train: AnyPublisher<[DominoView.State], Never>

    init(gameEngine: GameEngine, ruleSet: RuleSet, operations: Operations) {
        self.gameEngine = gameEngine
        self.ruleSet = ruleSet
        self.operations = operations

        localPlayerId = gameEngine.localPlayerId

        let gameData = gameEngine.gamePublisher
            .map { $0.gameData }
        let player = gameEngine.gamePublisher
            .compactMap { $0.localPlayer }

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

        let player1 = gameData
            .compactMap { $0.players[safe: 0] }
        let player2 = gameData
            .compactMap { $0.players[safe: 1] }

        player1Train = player1
            .map { $0.train.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

        player2Train = player2
            .map { $0.train.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

        subscription = gameEngine.gamePublisher
            .assign(to: \.latestGame, on: self)
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
