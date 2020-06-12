//
//  GameEngine.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import GameKit

typealias GameEngineAuthenticationBlock = (UIViewController?, Bool) -> Void

protocol GameEngine {
    var isAuthenticated: Bool { get }
    func authenticate(_ block: @escaping GameEngineAuthenticationBlock)
    func newMatchRequest(minPlayers: Int, maxPlayers: Int, inviteMessage: String) -> GKMatchRequest
}

class GameKitGameEngine: GameEngine {
    private let localPlayer = GKLocalPlayer.local

    var isAuthenticated: Bool {
        localPlayer.isAuthenticated
    }

    func authenticate(_ block: @escaping GameEngineAuthenticationBlock) {
        localPlayer.authenticateHandler = { [weak self] viewController, _ in
            block(viewController, self?.isAuthenticated ?? false)
        }
    }

    func newMatchRequest(minPlayers: Int, maxPlayers: Int, inviteMessage: String) -> GKMatchRequest {
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        request.inviteMessage = inviteMessage
        return request
    }
}
