//
//  MadogResolver.swift
//  MexicanTrain
//
//  Created by Home on 09/05/2020.
//

import Foundation
import Madog

class MadogResolver: Resolver<URL> {
    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [
            MadogServiceProviderImplementation.init(context:)
        ]
    }

    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<URL>] {
        [
        ]
    }
}
