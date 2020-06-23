//
//  PassOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PassOperation: Operation {
    func perform(game: Game) -> Game? {
        guard let currentPlayer = currentLocalPlayer(game: game),
            game.playerHasValidPlay(player: currentPlayer) == false,
            game.pool.isEmpty else {
            return nil
        }
        return game
    }
}
