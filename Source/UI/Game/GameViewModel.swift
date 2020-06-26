//
//  GameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import Foundation

enum DestinationTrain {
    case player(Int)
    case mexican
}

struct TrainState: Equatable {
    let dominoes: [DominoView.State]
    let isPlayable: Bool
}

protocol GameViewModelDelegate: AnyObject {
    func gameViewModelRoundDidFinish(_ viewModel: GameViewModel)
}

protocol GameViewModel {
    var delegate: GameViewModelDelegate? { get nonmutating set }

    var totalPlayerCount: Int { get }

    var currentPlayerTurn: AnyPublisher<Bool, Never> { get }
    var playerDominoes: AnyPublisher<[DominoView.State], Never> { get }
    var mexicanTrain: AnyPublisher<TrainState, Never> { get }

    func train(for player: Int) -> AnyPublisher<TrainState, Never>
    func canPlayDomino(at playerDominoIndex: Int, on destinationTrain: DestinationTrain) -> Bool
    func playDomino(at playerDominoIndex: Int, on destinationTrain: DestinationTrain, completion: @escaping (Bool) -> Void)
    func pickUp(completion: @escaping (Bool) -> Void)
    func pickUpTrain(at index: Int, completion: @escaping (Bool) -> Void)
}

class GameViewModelImpl: AbstractGameViewModelImpl, GameViewModel {
    let currentPlayerTurn: AnyPublisher<Bool, Never>
    let playerDominoes: AnyPublisher<[DominoView.State], Never>
    let mexicanTrain: AnyPublisher<TrainState, Never>

    weak var delegate: GameViewModelDelegate?

    private var subscription: AnyCancellable?

    override init(gameEngine: GameEngine, operations: Operations) {
        currentPlayerTurn = gameEngine.gamePublisher
            .map { gameEngine.engineState.currentLocalPlayer(game: $0) != nil }
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

        super.init(gameEngine: gameEngine, operations: operations)

        subscription = gameEngine.gamePublisher.sink { [weak self] game in
            guard let self = self else { return }
            if game.isLevelFinished {
                self.delegate?.gameViewModelRoundDidFinish(self)
            }
        }

        startRefreshTimer()
    }

    func train(for player: Int) -> AnyPublisher<TrainState, Never> {
        gameEngine.gamePublisher
            .compactMap { $0.players[safe: player]?.train }
            .map { $0.toState() }
            .removeDuplicates()
            .eraseToAnyPublisher()
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

        if update.isLevelFinished {
            let finished = update.withUpdatedScores()
            gameEngine.endTurn(game: finished, completion: completion)
        } else {
            let updateDoubleCount = update.openGates.count
            if updateDoubleCount > doubleCount {
                gameEngine.update(game: update, completion: completion)
            } else {
                gameEngine.endTurn(game: update, completion: completion)
            }
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
        guard index == gameEngine.engineState.localPlayerIndex,
            let update = operations.changeTrain.perform(game: latestGame) else {
            completion(false)
            return
        }

        gameEngine.update(game: update, completion: completion)
    }

    private func play(at playerDominoIndex: Int, on destinationTrain: DestinationTrain) -> Game? {
        guard let localPlayer = latestGame.player(id: gameEngine.engineState.localPlayerId),
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
