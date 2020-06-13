//
//  TypedViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import Madog
import UIKit

class TypedViewControllerProvider: SingleViewControllerProvider<MadogToken> {
    private var serviceProvider: MadogServiceProvider?

    override final func configure(with serviceProviders: [String: ServiceProvider]) {
        super.configure(with: serviceProviders)

        serviceProvider = serviceProviders[serviceProviderName] as? MadogServiceProvider
    }

    override final func createViewController(token: MadogToken, context: Context) -> UIViewController? {
        guard let serviceProvider = serviceProvider, let context = context as? ForwardBackNavigationContext else {
            return nil
        }

        return createViewController(token: token, context: context, serviceProvider: serviceProvider)
    }

    func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        // OVERRIDE POINT
        return nil
    }
}
