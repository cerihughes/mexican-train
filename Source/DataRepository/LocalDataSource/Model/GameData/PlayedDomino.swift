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

    private enum CodingKeys: String, CodingKey {
        case innerValue = "i"
        case outerValue = "o"
    }
}

extension PlayedDomino {
    var isDouble: Bool {
        innerValue == outerValue
    }

    func isDouble(_ value: DominoValue) -> Bool {
        isDouble && innerValue == value
    }
}
