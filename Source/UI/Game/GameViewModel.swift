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

    private var localPlayerId: String
    private var latestGame: GameState = GameState.createFakeGame()
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

        localPlayerId = gameEngine.localPlayerId

        let gameData = gameEngine.gamePublisher
            .map { $0.game }
        let player = gameEngine.gamePublisher
            .compactMap { $0.localPlayer }

        currentPlayerTurn = gameEngine.gamePublisher
            .map { $0.turn.isCurrentPlayer }
            .removeDuplicates()
            .eraseToAnyPublisher()

        playerDominoes = player
            .map { $0.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

        mexicanTrain = gameData
            .map { $0.mexicanTrain.toState() }
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

    func canPlayDomino(at playerDominoIndex: Int, on destinationTrain: DestinationTrain) -> Bool {
        play(at: playerDominoIndex, on: destinationTrain) != nil
    }

    func playDomino(at playerDominoIndex: Int, on destinationTrain: DestinationTrain, completion: @escaping (Bool) -> Void) {
        let doubleCount = latestGame.game.openGates.count
        guard let update = play(at: playerDominoIndex, on: destinationTrain) else {
            completion(false)
            return
        }

        let updateDoubleCount = update.openGates.count
        if updateDoubleCount > doubleCount {
            gameEngine.update(gameData: update, completion: completion)
        } else {
            gameEngine.endTurn(gameData: update, completion: completion)
        }
    }

    func pickUp(completion: @escaping (Bool) -> Void) {
        guard let currentLocalPlayer = latestGame.currentLocalPlayer,
            let update = operations.pickUp.perform(currentPlayer: currentLocalPlayer, game: latestGame.game) else {
            completion(false)
            return
        }

        gameEngine.endTurn(gameData: update, completion: completion)
    }

    func pickUpTrain(at index: Int, completion: @escaping (Bool) -> Void) {
        guard let currentLocalPlayer = latestGame.currentLocalPlayer,
            index == latestGame.turn.localPlayerIndex else {
            completion(false)
            return
        }

        let update = operations.changeTrain.perform(currentPlayer: currentLocalPlayer, game: latestGame.game)
        gameEngine.update(gameData: update, completion: completion)
    }

    private func play(at playerDominoIndex: Int, on destinationTrain: DestinationTrain) -> Game? {
        guard let currentLocalPlayer = latestGame.currentLocalPlayer,
            let localPlayerData = latestGame.game.player(id: localPlayerId),
            let unplayedDomino = localPlayerData.dominoes[safe: playerDominoIndex] else {
            return nil
        }
        return destinationTrain.update(operations: operations, currentPlayer: currentLocalPlayer, game: latestGame.game, unplayedDomino: unplayedDomino)
    }
}

private extension DestinationTrain {
    func update(operations: Operations, currentPlayer: Player, game: Game, unplayedDomino: UnplayedDomino) -> Game? {
        switch self {
        case let .player(index):
            guard let targetPlayer = game.players[safe: index] else {
                return nil
            }
            return operations.playOnPlayer.perform(currentPlayer: currentPlayer, game: game, domino: unplayedDomino, playerId: targetPlayer.id)
        case .mexican:
            return operations.playOnMexicanTrain.perform(currentPlayer: currentPlayer, game: game, domino: unplayedDomino)
        }
    }
}

private extension Publishers.Map where Upstream == Published<GameState>.Publisher, Output == Game {
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

extension GameState {
    var currentLocalPlayer: Player? {
        turn.isCurrentPlayer ? localPlayer : nil
    }

    var localPlayer: Player? {
        game.player(id: turn.localPlayerId)
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
