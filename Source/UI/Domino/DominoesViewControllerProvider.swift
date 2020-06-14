//
//  DominoesViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import Madog
import UIKit

class DominoesViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard token == .dominoesTest else {
            return nil
        }

        return DominoesViewController()
    }
}
