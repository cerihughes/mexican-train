//
//  NewGameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import GameKit
import UIKit

protocol NewGameViewModelDelegate: AnyObject {
    func newGameViewModelDidResume(_ viewModel: NewGameViewModel)
    func newGameViewModelDidStart(_ viewModel: NewGameViewModel)
    func newGameViewModelDidFailToStart(_ viewModel: NewGameViewModel)
}

protocol NewGameViewModel {
    var delegate: NewGameViewModelDelegate? { get nonmutating set }
    func createMatchRequest() -> GKMatchRequest
}

class NewGameViewModelImpl: NewGameViewModel {
    private let gameEngine: GameEngine
    private let setupGameOperation: SetupGameOperation

    weak var delegate: NewGameViewModelDelegate?

    init(gameEngine: GameEngine, setupGameOperation: SetupGameOperation) {
        self.gameEngine = gameEngine
        self.setupGameOperation = setupGameOperation

        gameEngine.addListener(self)
    }

    func createMatchRequest() -> GKMatchRequest {
        gameEngine.newMatchRequest(minPlayers: 2, maxPlayers: 4, inviteMessage: "Would you like to play Mexican Train?")
    }
}

extension NewGameViewModelImpl: GameEngineListener {
    func gameEngine(_ gameEngine: GameEngine, didReceive game: Game) {
        print("Function: \(#function), line: \(#line)")
        delegate?.newGameViewModelDidResume(self)
    }

    func gameEngine(_ gameEngine: GameEngine, didStartGameWith player: PlayerDetails, totalPlayerCount: Int) {
        print("Function: \(#function), line: \(#line)")
        print(player)
        let gameData = setupGameOperation.perform(playerId: player.id)
        gameEngine.update(gameData: gameData) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.delegate?.newGameViewModelDidStart(self)
            } else {
                self.delegate?.newGameViewModelDidFailToStart(self)
            }
        }
    }
}
