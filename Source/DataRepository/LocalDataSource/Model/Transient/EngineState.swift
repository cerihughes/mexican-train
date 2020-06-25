//
//  EngineState.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
//

import Foundation

struct EngineState {
    let totalPlayerCount: Int
    let playerDetails: [PlayerDetails]
    let localPlayerId: String
    let localPlayerIsCurrentPlayer: Bool
}

extension EngineState {
    var localPlayerIndex: Int? {
        playerDetails.firstIndex(where: { $0.id == localPlayerId })
    }

    var localPlayerDetails: PlayerDetails? {
        guard let localPlayerIndex = localPlayerIndex else { return nil }
        return playerDetails[safe: localPlayerIndex]
    }
}
