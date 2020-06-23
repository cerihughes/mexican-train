//
//  LevelSummaryViewControllerProvider.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Madog
import UIKit

class LevelSummaryViewControllerProvider: TypedViewControllerProvider {
    override func createViewController(token: MadogToken, context: ForwardBackNavigationContext, serviceProvider: MadogServiceProvider) -> UIViewController? {
        guard case let .levelSummary(stationValue) = token else {
            return nil
        }

        let viewModel = LevelSummaryViewModelImpl(stationValue: stationValue)
        return LevelSummaryViewController(viewModel: viewModel, context: context)
    }
}
