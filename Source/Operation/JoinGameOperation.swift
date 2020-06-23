//
//  JoinGameOperation.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import Foundation

class JoinGameOperation: Operation {
    func perform(game: Game) -> Game? {
        guard let localPlayerId = gameEngine.engineState?.localPlayerId else { return nil }
        let player = Player(id: localPlayerId,
                            dominoes: [],
                            train: Train(isPlayable: false, dominoes: []),
                            currentTurn: [],
                            score: 0)
        var players = game.players
        players.append(player)
        return game.with(players: players)
    }
}
