//
//  PassOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

class PassOperation {
    func perform(game: Game) -> Game? {
        return game.withIncrementedPlayer()
    }
}
