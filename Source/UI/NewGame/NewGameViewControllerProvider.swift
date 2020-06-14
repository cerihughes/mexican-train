//
//  NewGameViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Madog
import UIKit

class NewGameViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token == .newGame else {
            return nil
        }

        let viewModel = NewGameViewModelImpl(gameEngine: serviceProvider.gameEngine, setupGameOperation: serviceProvider.operations.setup)
        return NewGameViewController(viewModel: viewModel, context: context)
    }
}
