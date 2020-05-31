//
//  GameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import UIKit

protocol GameViewModel {
    var player1Dominoes: AnyPublisher<[UnplayedDomino], Never> { get }
    var player2Dominoes: AnyPublisher<[UnplayedDomino], Never> { get }

    var mexicanTrain: AnyPublisher<[PlayedDomino], Never> { get }
    var player1Train: AnyPublisher<[PlayedDomino], Never> { get }
    var player2Train: AnyPublisher<[PlayedDomino], Never> { get }

    func reload()
}

class GameViewModelImplementation: GameViewModel {
    private var game: Game

    private let gameSubject = PassthroughSubject<Game, Never>()

    let player1Dominoes: AnyPublisher<[UnplayedDomino], Never>
    let player2Dominoes: AnyPublisher<[UnplayedDomino], Never>
    let mexicanTrain: AnyPublisher<[PlayedDomino], Never>
    let player1Train: AnyPublisher<[PlayedDomino], Never>
    let player2Train: AnyPublisher<[PlayedDomino], Never>

    init(operation: SetupGameOperation) {
        game = operation.perform(playerNames: ["Player 1", "Player 2"])

        let player1 = gameSubject
            .map { $0.players[0] }
        let player2 = gameSubject
            .map { $0.players[1] }

        player1Dominoes = player1
            .map { $0.dominoes }
            .removeDuplicates()
            .eraseToAnyPublisher()

        player2Dominoes = player2
            .map { $0.dominoes }
            .removeDuplicates()
            .eraseToAnyPublisher()

        mexicanTrain = gameSubject
            .map { $0.mexicanTrain.dominoes }
            .removeDuplicates()
            .eraseToAnyPublisher()

        player1Train = player1
            .map { $0.train.dominoes }
            .removeDuplicates()
            .eraseToAnyPublisher()

        player2Train = player2
            .map { $0.train.dominoes }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func reload() {
        gameSubject.send(game)
    }
}
