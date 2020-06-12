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
    override func createViewController(token: MadogToken, context: Context) -> UIViewController? {
        guard token.identifier == authenticateGameIdentifier,
            let context = context as? ForwardBackNavigationContext,
            let serviceProvider = serviceProvider else {
            return nil
        }

        let viewModel = AuthenticateGameViewModelImpl(gameEngine: serviceProvider.gameEngine)
        return AuthenticateGameViewController(viewModel: viewModel, context: context)
    }
}

extension MadogToken {
    static let authenticateGame = MadogToken(identifier: authenticateGameIdentifier)
}
