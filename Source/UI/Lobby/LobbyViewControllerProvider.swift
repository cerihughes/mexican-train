//
//  LobbyViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Madog
import UIKit

class LobbyViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: Context, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard case let .lobby(stationValue) = token else {
            return nil
        }

        let viewModel = LobbyViewModelImpl(stationValue: stationValue, gameEngine: serviceProvider.gameEngine, operations: serviceProvider.operations)
        return LobbyViewController(viewModel: viewModel, context: context)
    }
}
