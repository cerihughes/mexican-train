//
//  UnplayedDomino.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct UnplayedDomino: Equatable, Codable {
    let value1: DominoValue
    let value2: DominoValue

    private enum CodingKeys: String, CodingKey {
        case value1 = "a"
        case value2 = "b"
    }
}

extension UnplayedDomino {
    static func allDominoes() -> [UnplayedDomino] {
        let allValues = DominoValue.allCases
        guard let first = allValues.first?.rawValue, let last = allValues.last?.rawValue else {
            return []
        }

        var allDominoes = [UnplayedDomino]()
        for value1 in first ... last {
            for value2 in value1 ... last {
                if let enum1 = DominoValue(rawValue: value1), let enum2 = DominoValue(rawValue: value2) {
                    allDominoes.append(UnplayedDomino(value1: enum1, value2: enum2))
                }
            }
        }

        return allDominoes
    }

    static func allDominoes(except stationValue: DominoValue) -> [UnplayedDomino] {
        allDominoes().removing(UnplayedDomino(value1: stationValue, value2: stationValue))
    }
}

extension UnplayedDomino {
    var isDouble: Bool {
        value1 == value2
    }

    func has(value: DominoValue) -> Bool {
        value1 == value || value2 == value
    }
}
