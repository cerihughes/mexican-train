//
//  PassOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PassOperation {
    func perform(currentPlayer: Player, game: Game) -> Game? {
        guard game.playerHasValidPlay(player: currentPlayer) == false,
            game.pool.isEmpty else {
            return nil
        }
        return game
    }
}
