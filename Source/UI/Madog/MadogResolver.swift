//
//  MadogResolver.swift
//  MexicanTrain
//
//  Created by Ceri on 09/05/2020.
//

import Foundation
import Madog

class MadogResolver: Resolver<MadogToken> {
    override func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [
            MadogServiceProviderImpl.init(context:)
        ]
    }

    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<MadogToken>] {
        [
            DominoesViewControllerProvider.init,
            AuthenticateGameViewControllerProvider.init,
            GameViewControllerProvider.init
        ]
    }
}
