//
//  AuthenticateGameViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Madog
import UIKit

protocol AuthenticateGameViewModel {
    func authenticate(context: ForwardBackNavigationContext?, _ block: @escaping (UIViewController) -> Void)
}

class AuthenticateGameViewModelImpl: AuthenticateGameViewModel {
    private let gameEngine: GameEngine

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }

    func authenticate(context: ForwardBackNavigationContext?, _ block: @escaping (UIViewController) -> Void) {
        gameEngine.authenticate { viewController, isAuthenticated in
            if isAuthenticated {
                context?.navigateForward(token: MadogToken.newGame, animated: true)
            } else if let viewController = viewController {
                block(viewController)
            }
        }
    }
}
