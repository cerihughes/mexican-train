//
//  TypedViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import Madog
import UIKit

class TypedViewControllerProvider: SingleViewControllerProvider<MadogToken> {
    var serviceProvider: MadogServiceProvider?

    override final func configure(with serviceProviders: [String: ServiceProvider]) {
        super.configure(with: serviceProviders)

        serviceProvider = serviceProviders[serviceProviderName] as? MadogServiceProvider
    }
}
