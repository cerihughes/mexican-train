//
//  GameViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 31/05/2020.
//

import Madog
import UIKit

class GameViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: Context, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token == .playGame else {
            return nil
        }

        let viewModel = GameViewModelImpl(gameEngine: serviceProvider.gameEngine, operations: serviceProvider.operations)
        return GameViewController(viewModel: viewModel)
    }
}
