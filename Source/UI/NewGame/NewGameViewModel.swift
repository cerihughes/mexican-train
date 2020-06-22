//
//  NewGameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import GameKit
import UIKit

protocol NewGameViewModelDelegate: AnyObject {
    func newGameViewModel(_ viewModel: NewGameViewModel, didResumeGame totalPlayerCount: Int)
    func newGameViewModel(_ viewModel: NewGameViewModel, didStartGame totalPlayerCount: Int)
    func newGameViewModelDidFailToStartGame(_ viewModel: NewGameViewModel)
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
    func gameEngine(_ gameEngine: GameEngine, didReceive state: GameState) {
        print("Function: \(#function), line: \(#line)")
        if state.localPlayer != nil {
            delegate?.newGameViewModel(self, didResumeGame: state.turn.totalPlayerCount)
        } else {
            let gameData = operations.joinGame.perform(game: state.game, playerId: gameEngine.localPlayerId)
            gameEngine.update(gameData: gameData) { print($0) }
        }
    }

    func gameEngine(_ gameEngine: GameEngine, didStartGameWith player: PlayerDetails, totalPlayerCount: Int) {
        print("Function: \(#function), line: \(#line)")
        print(player)
        let gameData = operations.setup.perform(playerId: player.id)
        gameEngine.update(gameData: gameData) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.delegate?.newGameViewModel(self, didStartGame: totalPlayerCount)
            } else {
                self.delegate?.newGameViewModelDidFailToStartGame(self)
            }
        }
    }
}
