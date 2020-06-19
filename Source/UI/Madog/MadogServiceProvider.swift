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
    var localDataSource: LocalDataSource { get }
    var ruleSet: RuleSet { get }
    var operations: Operations { get }
}

class MadogServiceProviderImpl: ServiceProvider, MadogServiceProvider {
    let gameEngine: GameEngine
    let localDataSource: LocalDataSource
    let ruleSet: RuleSet
    let operations: Operations

    // MARK: - ServiceProvider

    override init(context: ServiceProviderCreationContext) {
        gameEngine = GameKitGameEngine()
        localDataSource = LocalDataSourceImpl()
        let shuffler = ShufflerImpl()
        ruleSet = StandardRuleSet()
        operations = Operations(ruleSet: ruleSet, shuffler: shuffler)

        super.init(context: context)

        name = serviceProviderName
    }
}
