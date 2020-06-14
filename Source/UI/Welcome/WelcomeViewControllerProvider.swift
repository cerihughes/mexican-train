//
//  WelcomeViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 14/06/2020.
//

import Madog
import UIKit

class WelcomeViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token == .welcome else {
            return nil
        }

        let viewModel = WelcomeViewModelImpl(gameEngine: serviceProvider.gameEngine)
        return WelcomeViewController(viewModel: viewModel, context: context)
    }
}
