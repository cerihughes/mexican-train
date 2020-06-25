//
//  AbstractGameViewModelImpl.swift
//  MexicanTrain
//
//  Created by Home on 23/06/2020.
//

import Combine
import Foundation

class AbstractGameViewModelImpl {
    let gameEngine: GameEngine
    let operations: Operations

    var latestGame = Game.empty
    private var timer: Timer?
    private var subscription: AnyCancellable?

    init(gameEngine: GameEngine, operations: Operations) {
        self.gameEngine = gameEngine
        self.operations = operations

        subscription = gameEngine.gamePublisher
            .assign(to: \.latestGame, on: self)
    }

    func startRefreshTimer(interval: TimeInterval = 10.0) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in self?.gameEngine.refresh() }
    }

    func stopRefreshTimer() {
        timer?.invalidate()
    }

    var totalPlayerCount: Int {
        gameEngine.engineState.totalPlayerCount
    }
}
