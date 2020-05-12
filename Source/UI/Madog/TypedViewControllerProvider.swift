//
//  TypedViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import Madog
import UIKit

class TypedViewControllerProvider: ViewControllerProvider<MadogToken> {
    private var uuid: UUID?
    override func register(with registry: Registry<MadogToken>) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    override func unregister(from registry: Registry<MadogToken>) {
        uuid.map { registry.removeRegistryFunction(uuid: $0) }
    }

    func createViewController(token: MadogToken, context: Context) -> UIViewController? {
        return nil
    }
}
