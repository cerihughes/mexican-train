//
//  LobbyViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Foundation

protocol LobbyViewModel {}

class LobbyViewModelImpl: LobbyViewModel {
    private let stationValue: DominoValue

    init(stationValue: DominoValue) {
        self.stationValue = stationValue
    }
}
