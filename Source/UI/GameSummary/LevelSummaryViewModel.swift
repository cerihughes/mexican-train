//
//  LevelSummaryViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Foundation

protocol LevelSummaryViewModel {}

class LevelSummaryViewModelImpl: LevelSummaryViewModel {
    private let stationValue: DominoValue

    init(stationValue: DominoValue) {
        self.stationValue = stationValue
    }
}
