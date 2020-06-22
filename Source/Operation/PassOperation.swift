//
//  PassOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PassOperation {
    func perform(game: GameTurn) -> Game? {
        guard game.currentLocalPlayerHasValidPlay == false,
            game.gameData.pool.isEmpty else {
            return nil
        }

        return game.gameData
    }
}
