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
