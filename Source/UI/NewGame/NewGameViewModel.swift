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
    func createMatchRequest() -> GKMatchRequest
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

    func createMatchRequest() -> GKMatchRequest {
        gameEngine.newMatchRequest(minPlayers: 2, maxPlayers: 4, inviteMessage: "Would you like to play Mexican Train?")
    }
}

extension NewGameViewModelImpl: GameEngineListener {
    func gameEngine(_ gameEngine: GameEngine, didReceive game: Game) {
        print("Function: \(#function), line: \(#line)")
        let gameData = game.gameData
        let token: MadogToken
        if gameData.isFinished {
            token = .levelSummary(.zero)
        } else if gameData.isLevelFinished {
            token = .levelSummary(gameData.stationValue)
        } else if gameData.isPlayingLevel {
            token = .playGame(game.totalPlayerCount)
        } else {
            token = .welcome
        }
        delegate?.newGameViewModel(self, navigateTo: token)
//        if game.localPlayer != nil {
//            delegate?.newGameViewModel(self, didResumeGame: game.totalPlayerCount)
//        } else {
//            let gameData = operations.joinGame.perform(game: game, playerId: gameEngine.localPlayerId)
//            gameEngine.update(gameData: gameData) { print($0) }
//        }
    }

//    func gameEngine(_ gameEngine: GameEngine, didStartGameWith totalPlayerCount: Int) {
//        print("Function: \(#function), line: \(#line)")
//        let gameData = operations.setup.perform(playerId: player.id)
//        gameEngine.update(gameData: gameData) { [weak self] success in
//            guard let self = self else { return }
//            if success {
//                self.delegate?.newGameViewModel(self, didStartGame: totalPlayerCount)
//            } else {
//                self.delegate?.newGameViewModelDidFailToStartGame(self)
//            }
//        }
//    }
}

private extension GameData {
    var isFinished: Bool {
        false // TODO : <- This
    }

    var isLevelFinished: Bool {
        true
    }

    var isPlayingLevel: Bool {
        true
    }
}
