//
//  GameViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 31/05/2020.
//

import Madog
import UIKit

class GameViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard case let .gameTest(totalPlayerCount) = token else {
            return nil
        }

        let viewModel = GameViewModelImpl(gameEngine: serviceProvider.gameEngine,
                                          operations: serviceProvider.operations,
                                          totalPlayerCount: totalPlayerCount)
        return GameViewController(viewModel: viewModel)
    }
}
