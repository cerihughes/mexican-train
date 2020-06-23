//
//  NewGameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import GameKit
import UIKit

protocol NewGameViewModelDelegate: AnyObject {
    func newGameViewModel(_ viewModel: NewGameViewModel, navigateTo token: MadogToken)
}

protocol NewGameViewModel {
    var delegate: NewGameViewModelDelegate? { get nonmutating set }
}

class NewGameViewModelImpl: NewGameViewModel {
    private let gameEngine: GameEngine
    private let operations: Operations

    weak var delegate: NewGameViewModelDelegate?

    init(gameEngine: GameEngine, operations: Operations) {
        self.gameEngine = gameEngine
        self.operations = operations

        gameEngine.addListener(self)
    }
}

extension NewGameViewModelImpl: GameEngineListener {
    func gameEngine(_ gameEngine: GameEngine, didReceive game: Game) {
        print("Function: \(#function), line: \(#line)")
        guard let engineState = gameEngine.engineState else { return }

        let token: MadogToken
        if game.isFinished {
            token = .welcome
        } else if game.isLevelFinished {
            token = .welcome
        } else if game.isPlayingLevel {
            token = .gameTest(engineState.totalPlayerCount)
        } else {
            token = .welcome
        }
        delegate?.newGameViewModel(self, navigateTo: token)
    }
}

private extension Game {
    var isFinished: Bool {
        stationValue == .zero && isLevelFinished
    }

    var isLevelFinished: Bool {
        stationValue != .zero && players.anySatisfies { $0.hasPlayedAllDominoes }
    }

    var isPlayingLevel: Bool {
        !isFinished && !isLevelFinished && players.allSatisfy { $0.isPlayingLevel }
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
