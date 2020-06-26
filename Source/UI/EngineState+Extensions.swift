//
//  EngineState+Extensions.swift
//  MexicanTrain
//
//  Created by Home on 26/06/2020.
//

import Foundation

extension EngineState {
    func currentLocalPlayer(game: Game) -> Player? {
        guard localPlayerIsCurrentPlayer else { return nil }
        return localPlayer(game: game)
    }

    func localPlayer(game: Game) -> Player? {
        return game.player(id: localPlayerId)
    }
}
