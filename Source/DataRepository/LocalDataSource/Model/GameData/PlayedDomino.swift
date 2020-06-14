//
//  PlayedDomino.swift
//  MexicanTrain
//
//  Created by Ceri on 17/05/2020.
//

import Foundation

struct PlayedDomino: Equatable, Codable {
    let innerValue: DominoValue
    let outerValue: DominoValue
}