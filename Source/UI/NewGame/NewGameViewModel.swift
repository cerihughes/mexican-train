//
//  NewGameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import GameKit
import UIKit

protocol NewGameViewModel {
    func createMatchRequest() -> GKMatchRequest
}

class NewGameViewModelImpl: NewGameViewModel {
    private let gameEngine: GameEngine
    private let setupGameOperation: SetupGameOperation

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
    func gameEngine(_ gameEngine: GameEngine, didReceive game: GameData) {
        print("Function: \(#function), line: \(#line)")
        print(game)
    }

    func gameEngine(_ gameEngine: GameEngine, didStartGameWith player: PlayerDetails, totalPlayerCount: Int) {
        print("Function: \(#function), line: \(#line)")
        print(player)
        let gameData = setupGameOperation.perform(playerId: player.id)
        gameEngine.update(gameData: gameData) { print($0) }
    }
}
