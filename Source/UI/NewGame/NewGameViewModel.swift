//
//  NewGameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Combine
import Foundation
import GameKit

protocol NewGameViewModelDelegate: AnyObject {
    func newGameViewModel(_ viewModel: NewGameViewModel, navigateTo token: MadogToken)
}

protocol NewGameViewModel {
    var delegate: NewGameViewModelDelegate? { get nonmutating set }
}

class NewGameViewModelImpl: NewGameViewModel {
    private let gameEngine: GameEngine
    private let operations: Operations
    private var subscription: AnyCancellable?

    weak var delegate: NewGameViewModelDelegate?

    init(gameEngine: GameEngine, operations: Operations) {
        self.gameEngine = gameEngine
        self.operations = operations

        subscription = gameEngine.gamePublisher
            .sink { [weak self] in self?.gameUpdated($0) }
    }

    private func gameUpdated(_ game: Game) {
        if game.isLevelFinished {
            gameLevelFinished(game)
        } else if game.isPlayingLevel {
            gameInProgress(game)
        } else {
            gameStarted(game)
        }
        subscription = nil
    }

    private func gameLevelFinished(_ game: Game) {
        let token: MadogToken
        if let nextLevel = game.stationValue.nextValue {
            token = .lobby(nextLevel)
        } else {
            token = .welcome // TODO: Game summary
        }
        delegate?.newGameViewModel(self, navigateTo: token)
    }

    private func gameInProgress(_ game: Game) {
        delegate?.newGameViewModel(self, navigateTo: .gameTest)
    }

    private func gameStarted(_ game: Game) {
        delegate?.newGameViewModel(self, navigateTo: .lobby(.twelve))
    }
}

private extension Game {
    var isLevelFinished: Bool {
        players.anySatisfies { $0.hasPlayedAllDominoes }
    }

    var isPlayingLevel: Bool {
        !isLevelFinished && players.count > 1 && players.allSatisfy { $0.isPlayingLevel }
    }
}

private extension Player {
    var hasPlayedAllDominoes: Bool {
        dominoes.isEmpty && train.isStarted
    }

    var isPlayingLevel: Bool {
        !dominoes.isEmpty
    }
}

private extension DominoValue {
    var nextValue: DominoValue? {
        DominoValue(rawValue: rawValue - 1)
    }
}
