//
//  GameEngineListenerContainer.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Foundation

class GameEngineListenerContainer {
    private struct WeakWrapper {
        weak var wrapped: GameEngineListener?
    }

    private var weakListeners = [WeakWrapper]()

    func addListener(_ listener: GameEngineListener) {
        weakListeners.append(WeakWrapper(wrapped: listener))
    }

    var listeners: [GameEngineListener] {
        weakListeners.compactMap { $0.wrapped }
    }
}

extension GameEngineListenerContainer: GameEngineListener {
    func gameEngine(_ gameEngine: GameEngine, didReceive game: Game) {
        listeners.forEach {
            $0.gameEngine(gameEngine, didReceive: game)
        }
    }

    func gameEngine(_ gameEngine: GameEngine, didStartGameWith players: [Player.Details]) {
        listeners.forEach {
            $0.gameEngine(gameEngine, didStartGameWith: players)
        }
    }
}