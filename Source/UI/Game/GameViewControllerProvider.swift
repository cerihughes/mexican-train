//
//  GameViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 31/05/2020.
//

import Madog
import UIKit

private let gameTestIdentifier = "gameTest"

class GameViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token.identifier == gameTestIdentifier else {
            return nil
        }

        let viewModel = GameViewModelImpl(operation: serviceProvider.operations.setup)
        return GameViewController(viewModel: viewModel)
    }
}

extension MadogToken {
    static let gameTest = MadogToken(identifier: gameTestIdentifier)
}
