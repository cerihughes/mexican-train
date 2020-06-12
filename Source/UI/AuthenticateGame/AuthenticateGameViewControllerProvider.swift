//
//  AuthenticateGameViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Madog
import UIKit

private let authenticateGameIdentifier = "authenticateGame"

class AuthenticateGameViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token.identifier == authenticateGameIdentifier else {
            return nil
        }

        let viewModel = AuthenticateGameViewModelImpl(gameEngine: serviceProvider.gameEngine)
        return AuthenticateGameViewController(viewModel: viewModel, context: context)
    }
}

extension MadogToken {
    static let authenticateGame = MadogToken(identifier: authenticateGameIdentifier)
}
