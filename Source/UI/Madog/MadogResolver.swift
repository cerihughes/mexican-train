//
//  MadogResolver.swift
//  MexicanTrain
//
//  Created by Ceri on 09/05/2020.
//

import Foundation
import Madog

class MadogResolver: Resolver<MadogToken> {
    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [
            MadogServiceProviderImplementation.init(context:)
        ]
    }

    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<MadogToken>] {
        [
            DominoesViewControllerProvider.init
        ]
    }
}
