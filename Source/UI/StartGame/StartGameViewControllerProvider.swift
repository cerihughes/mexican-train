//
//  StartGameViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Madog
import UIKit

class StartGameViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: Context, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token == .startGame else {
            return nil
        }

        let viewModel = StartGameViewModelImpl(gameEngine: serviceProvider.gameEngine, operations: serviceProvider.operations)
        return StartGameViewController(viewModel: viewModel, context: context)
    }
}
