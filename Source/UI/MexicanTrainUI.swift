//
//  MexicanTrainUI.swift
//  MexicanTrain
//
//  Created by Ceri on 09/05/2020.
//

import Madog
import UIKit

class MexicanTrainUI {
    private let window: UIWindow
    private let madog = Madog<MadogToken>()

    init(window: UIWindow) {
        self.window = window
        madog.resolve(resolver: MadogResolver())
    }

    func showInitialUI() -> Bool {
        let context = madog.renderUI(identifier: .navigation, tokenData: .single(MadogToken.welcome), in: window) {
            $0.setNavigationBarHidden(true, animated: false)
        }
        return context != nil
    }

    // MARK: - Private

    private var serviceProvider: MadogServiceProvider? {
        return madog.serviceProviders[serviceProviderName] as? MadogServiceProvider
    }
}

extension Context {
    func navigate(to token: MadogToken) {
        change(to: .basic, tokenData: .single(token), transition: Transition(duration: 1, options: .transitionCrossDissolve))
    }
}
