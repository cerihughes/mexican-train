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
        let identifier = SingleUIIdentifier.createNavigationControllerIdentifier { $0.setNavigationBarHidden(true, animated: false) }
        let context = madog.renderUI(identifier: identifier, token: MadogToken.dominoesTest, in: window)
        return context != nil
    }

    // MARK: - Private

    private var serviceProvider: MadogServiceProvider? {
        return madog.serviceProviders[serviceProviderName] as? MadogServiceProvider
    }
}
