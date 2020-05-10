//
//  MadogServiceProvider.swift
//  MexicanTrain
//
//  Created by Home on 09/05/2020.
//

import Foundation
import Madog

let serviceProviderName = "serviceProviderName"

protocol MadogServiceProvider {
    var localDataSource: LocalDataSource { get }
}

class MadogServiceProviderImplementation: ServiceProvider, MadogServiceProvider {
    let localDataSource: LocalDataSource

    // MARK: - ServiceProvider

    override init(context: ServiceProviderCreationContext) {
        localDataSource = LocalDataSourceImplementation()

        super.init(context: context)

        name = serviceProviderName
    }
}
