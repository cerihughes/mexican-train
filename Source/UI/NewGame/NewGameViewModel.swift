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

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
        gameEngine.addListener(self)
    }

    func createMatchRequest() -> GKMatchRequest {
        gameEngine.newMatchRequest(minPlayers: 2, maxPlayers: 4, inviteMessage: "Would you like to play Mexican Train?")
    }
}

extension NewGameViewModelImpl: GameEngineListener {
    func gameEngine(_ gameEngine: GameEngine, didReceive game: Game) {
        print("Function: \(#function), line: \(#line)")
        print(game)
    }

    func gameEngine(_ gameEngine: GameEngine, didStartGameWith players: [Player]) {
        print("Function: \(#function), line: \(#line)")
        print(players)
    }
}
