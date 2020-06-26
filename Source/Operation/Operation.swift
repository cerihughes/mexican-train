//
//  Operation.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Foundation

class Operation {
    let gameEngine: GameEngine

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }

    func currentLocalPlayer(game: Game) -> Player? {
        gameEngine.engineState.currentLocalPlayer(game: game)
    }
}
