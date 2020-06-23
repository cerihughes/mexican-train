//
//  GameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import UIKit

enum DestinationTrain {
    case player(Int)
    case mexican
}

struct TrainState: Equatable {
    let dominoes: [DominoView.State]
    let isPlayable: Bool
}

protocol GameViewModel {
    var totalPlayerCount: Int { get }

    var currentPlayerTurn: AnyPublisher<Bool, Never> { get }
    var playerDominoes: AnyPublisher<[DominoView.State], Never> { get }
    var mexicanTrain: AnyPublisher<TrainState, Never> { get }
    var player1Train: AnyPublisher<TrainState, Never> { get }
    var player2Train: AnyPublisher<TrainState, Never> { get }
    var player3Train: AnyPublisher<TrainState, Never> { get }
    var player4Train: AnyPublisher<TrainState, Never> { get }

    func canPlayDomino(at playerDominoIndex: Int, on destinationTrain: DestinationTrain) -> Bool
    func playDomino(at playerDominoIndex: Int, on destinationTrain: DestinationTrain, completion: @escaping (Bool) -> Void)
    func pickUp(completion: @escaping (Bool) -> Void)
    func pickUpTrain(at index: Int, completion: @escaping (Bool) -> Void)
}

extension GameViewModel {
    func train(for player: Int) -> AnyPublisher<TrainState, Never>? {
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
    private let operations: Operations

    private var latestGame = Game.createInitialGame()
    private var subscription: AnyCancellable?
    private var timer: Timer?

    let totalPlayerCount: Int
    let currentPlayerTurn: AnyPublisher<Bool, Never>
    let playerDominoes: AnyPublisher<[DominoView.State], Never>
    let mexicanTrain: AnyPublisher<TrainState, Never>
    let player1Train: AnyPublisher<TrainState, Never>
    let player2Train: AnyPublisher<TrainState, Never>
    let player3Train: AnyPublisher<TrainState, Never>
    let player4Train: AnyPublisher<TrainState, Never>

    init(gameEngine: GameEngine, operations: Operations, totalPlayerCount: Int) {
        self.gameEngine = gameEngine
        self.operations = operations
        self.totalPlayerCount = totalPlayerCount

        currentPlayerTurn = gameEngine.gamePublisher
            .map { gameEngine.engineState?.currentLocalPlayer(game: $0) != nil }
            .removeDuplicates()
            .eraseToAnyPublisher()

        playerDominoes = gameEngine.localPlayerPublisher
            .map { $0.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

        mexicanTrain = gameEngine.gamePublisher
            .map { $0.mexicanTrain.toState() }
            .removeDuplicates()
            .eraseToAnyPublisher()

        player1Train = gameEngine.gamePublisher
            .playerTrain(at: 0)

        player2Train = gameEngine.gamePublisher
            .playerTrain(at: 1)

        player3Train = gameEngine.gamePublisher
            .playerTrain(at: 2)

        player4Train = gameEngine.gamePublisher
            .playerTrain(at: 3)

        subscription = gameEngine.gamePublisher
            .assign(to: \.latestGame, on: self)

        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            gameEngine.refresh()
        }
    }

    func canPlayDomino(at playerDominoIndex: Int, on destinationTrain: DestinationTrain) -> Bool {
        play(at: playerDominoIndex, on: destinationTrain) != nil
    }

    func playDomino(at playerDominoIndex: Int, on destinationTrain: DestinationTrain, completion: @escaping (Bool) -> Void) {
        let doubleCount = latestGame.openGates.count
        guard let update = play(at: playerDominoIndex, on: destinationTrain) else {
            completion(false)
            return
        }

        let updateDoubleCount = update.openGates.count
        if updateDoubleCount > doubleCount {
            gameEngine.update(game: update, completion: completion)
        } else {
            gameEngine.endTurn(game: update, completion: completion)
        }
    }

    func pickUp(completion: @escaping (Bool) -> Void) {
        guard let update = operations.pickUp.perform(game: latestGame) else {
            completion(false)
            return
        }

        gameEngine.endTurn(game: update, completion: completion)
    }

    func pickUpTrain(at index: Int, completion: @escaping (Bool) -> Void) {
        guard index == gameEngine.engineState?.localPlayerIndex,
            let update = operations.changeTrain.perform(game: latestGame) else {
            completion(false)
            return
        }

        gameEngine.update(game: update, completion: completion)
    }

    private func play(at playerDominoIndex: Int, on destinationTrain: DestinationTrain) -> Game? {
        guard let localPlayerId = gameEngine.engineState?.localPlayerId,
            let localPlayer = latestGame.player(id: localPlayerId),
            let unplayedDomino = localPlayer.dominoes[safe: playerDominoIndex] else {
            return nil
        }
        return destinationTrain.update(operations: operations, game: latestGame, unplayedDomino: unplayedDomino)
    }
}

private extension DestinationTrain {
    func update(operations: Operations, game: Game, unplayedDomino: UnplayedDomino) -> Game? {
        switch self {
        case let .player(index):
            guard let targetPlayer = game.players[safe: index] else {
                return nil
            }
            return operations.playOnPlayer.perform(game: game, domino: unplayedDomino, playerId: targetPlayer.id)
        case .mexican:
            return operations.playOnMexicanTrain.perform(game: game, domino: unplayedDomino)
        }
    }
}

private extension Published.Publisher where Value == Game {
    func playerTrain(at index: Int) -> AnyPublisher<TrainState, Never> {
        return compactMap { $0.players[safe: index]?.train }
            .map { $0.toState() }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

private extension Train {
    func toState() -> TrainState {
        let dominoStates = dominoes.map { $0.faceUpState }
        return TrainState(dominoes: dominoStates, isPlayable: isPlayable)
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
