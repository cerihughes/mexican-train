//
//  MadogToken.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

enum MadogToken: Equatable {
    case welcome
    case startGame
    case lobby(DominoValue)
    case playGame
}
