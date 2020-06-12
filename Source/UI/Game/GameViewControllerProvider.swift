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
    override func createViewController(token: MadogToken, context: Context) -> UIViewController? {
        guard token.identifier == gameTestIdentifier,
            let serviceProvider = serviceProvider else {
            return nil
        }

        let viewModel = GameViewModelImpl(operation: serviceProvider.setupGameOperation)
        return GameViewController(viewModel: viewModel)
    }
}

extension MadogToken {
    static let gameTest = MadogToken(identifier: gameTestIdentifier)
}
