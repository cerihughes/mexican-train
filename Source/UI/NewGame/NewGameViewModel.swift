//
//  NewGameViewModel.swift
//  MexicanTrain
//
//  Created by Home on 12/06/2020.
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
    }

    func createMatchRequest() -> GKMatchRequest {
        gameEngine.newMatchRequest(minPlayers: 2, maxPlayers: 4, inviteMessage: "Would you like to play Mexican Train?")
    }
}
