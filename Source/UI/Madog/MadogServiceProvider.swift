//
//  MadogServiceProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 09/05/2020.
//

import Foundation
import Madog

let serviceProviderName = "serviceProviderName"

protocol MadogServiceProvider {
    var gameEngine: GameEngine { get }
    var shuffler: Shuffler { get }
    var localDataSource: LocalDataSource { get }
    var setupGameOperation: SetupGameOperation { get }
}

class MadogServiceProviderImplementation: ServiceProvider, MadogServiceProvider {
    let gameEngine: GameEngine
    let shuffler: Shuffler
    let localDataSource: LocalDataSource
    let setupGameOperation: SetupGameOperation

    // MARK: - ServiceProvider

    override init(context: ServiceProviderCreationContext) {
        gameEngine = GameKitGameEngine()
        shuffler = ShufflerImplementation()
        localDataSource = LocalDataSourceImplementation()
        setupGameOperation = SetupGameOperation(shuffler: shuffler)

        super.init(context: context)

        name = serviceProviderName
    }
}
