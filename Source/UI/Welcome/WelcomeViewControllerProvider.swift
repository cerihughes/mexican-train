//
//  WelcomeViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 14/06/2020.
//

import Madog
import UIKit

private let welcomeIdentifier = "welcome"

class WelcomeViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token.identifier == welcomeIdentifier else {
            return nil
        }

        let viewModel = WelcomeViewModelImpl()
        return WelcomeViewController(viewModel: viewModel, context: context)
    }
}

extension MadogToken {
    static let welcome = MadogToken(identifier: welcomeIdentifier)
}
