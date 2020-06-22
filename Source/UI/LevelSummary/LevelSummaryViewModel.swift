//
//  LevelSummaryViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Foundation

protocol LevelSummaryViewModel {}

class LevelSummaryViewModelImpl: LevelSummaryViewModel {
    private let level: DominoValue

    init(level: DominoValue) {
        self.level = level
    }
}
