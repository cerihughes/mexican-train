//
//  GameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import UIKit

protocol GameViewModel {
    var player1Dominoes: AnyPublisher<[DominoView.State], Never> { get }
    var player2Dominoes: AnyPublisher<[DominoView.State], Never> { get }

    var mexicanTrain: AnyPublisher<[DominoView.State], Never> { get }
    var player1Train: AnyPublisher<[DominoView.State], Never> { get }
    var player2Train: AnyPublisher<[DominoView.State], Never> { get }

    func reload()
}

class GameViewModelImpl: GameViewModel {
    private var game: Game

    private let gameSubject = PassthroughSubject<Game, Never>()

    let player1Dominoes: AnyPublisher<[DominoView.State], Never>
    let player2Dominoes: AnyPublisher<[DominoView.State], Never>
    let mexicanTrain: AnyPublisher<[DominoView.State], Never>
    let player1Train: AnyPublisher<[DominoView.State], Never>
    let player2Train: AnyPublisher<[DominoView.State], Never>

    init(operation: SetupGameOperation) {
        let playerDetails = [
            Player.Details(id: "P1", name: "Player1"),
            Player.Details(id: "P2", name: "Player2")
        ]
        game = operation.perform(playerDetails: playerDetails, initialPlayerId: "P1")

        let player1 = gameSubject
            .map { $0.players[0] }
        let player2 = gameSubject
            .map { $0.players[1] }

        player1Dominoes = player1
            .map { $0.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

        player2Dominoes = player2
            .map { $0.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

        mexicanTrain = gameSubject
            .map { $0.mexicanTrain.dominoes }
            .arrayMap { $0.faceUpState }
            .removeDuplicates()
            .eraseToAnyPublisher()

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
    }

    func reload() {
        gameSubject.send(game)
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
