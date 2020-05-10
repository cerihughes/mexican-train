//
//  MexicanTrainUI.swift
//  MexicanTrain
//
//  Created by Home on 09/05/2020.
//

import Madog
import UIKit

class MexicanTrainUI {
    private let window: UIWindow
    private let madog = Madog<URL>()

    init(window: UIWindow) {
        self.window = window
        madog.resolve(resolver: MadogResolver())
    }

    func showInitialUI() -> Bool {
        window.rootViewController = GameViewController()
        return true
    }

    // MARK: - Private

    private var serviceProvider: MadogServiceProvider? {
        return madog.serviceProviders[serviceProviderName] as? MadogServiceProvider
    }
}
