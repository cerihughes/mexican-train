//
//  WelcomeViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 14/06/2020.
//

import Madog
import UIKit

protocol WelcomeViewModel {
    var authenticatingMessage: String { get }
    var authenticatedMessage: String { get }
    var authenticatingErrorMessage: String { get }
    var buttonTitle: String { get }
    func authenticate(_ block: @escaping (UIViewController?, Bool) -> Void)
}

class WelcomeViewModelImpl: WelcomeViewModel {
    private let gameEngine: GameEngine

    let authenticatingMessage = "Authenticating..."
    let authenticatedMessage = "Authenticated!"
    let authenticatingErrorMessage = "Could not authenticate!"
    let buttonTitle = "Games"

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
    }

    func authenticate(_ block: @escaping (UIViewController?, Bool) -> Void) {
        gameEngine.authenticate(block)
    }
}
