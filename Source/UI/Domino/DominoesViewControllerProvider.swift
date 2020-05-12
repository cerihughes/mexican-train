//
//  DominoesViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import Madog
import UIKit

private let dominoesTestIdentifier = "dominoesTest"

class DominoesViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: Context) -> UIViewController? {
        guard token.identifier == dominoesTestIdentifier else {
            return nil
        }

        return DominoesViewController()
    }
}

extension MadogToken {
    static let dominoesTest = MadogToken(identifier: dominoesTestIdentifier)
}
