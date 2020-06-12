//
//  CreateGameViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Madog
import UIKit

private let createGameIdentifier = "createGame"

class CreateGameViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: Context) -> UIViewController? {
        guard token.identifier == createGameIdentifier,
            let context = context as? ForwardBackNavigationContext,
            let serviceProvider = serviceProvider else {
            return nil
        }

        let viewModel = CreateGameViewModelImpl(gameEngine: serviceProvider.gameEngine)
        return CreateGameViewController(viewModel: viewModel, context: context)
    }
}

extension MadogToken {
    static let createGame = MadogToken(identifier: createGameIdentifier)
}
