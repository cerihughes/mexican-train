//
//  LobbyViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Madog
import UIKit

class LobbyViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token == .lobby else {
            return nil
        }

        let viewModel = LobbyViewModelImpl()
        return LobbyViewController(viewModel: viewModel, context: context)
    }
}
