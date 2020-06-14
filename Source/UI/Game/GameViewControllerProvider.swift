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
        guard token == .gameTest else {
            return nil
        }

        let viewModel = GameViewModelImpl(operation: serviceProvider.operations.setup)
        return GameViewController(viewModel: viewModel)
    }
}
