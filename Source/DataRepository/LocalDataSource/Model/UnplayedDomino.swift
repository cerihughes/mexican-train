//
//  UnplayedDomino.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct UnplayedDomino: Equatable {
    let value1: DominoValue
    let value2: DominoValue
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
}

extension UnplayedDomino {
    var pointsValue: Int {
        value1.rawValue + value2.rawValue
    }

    func playedDomino(on value: DominoValue) -> PlayedDomino? {
        guard has(value: value) else {
            return nil
        }

        if value1 == value {
            return PlayedDomino(innerValue: value1, outerValue: value2)
        } else {
            return PlayedDomino(innerValue: value2, outerValue: value1)
        }
    }

    func has(value: DominoValue) -> Bool {
        value1 == value || value2 == value
    }

    func isPlayable(with oneOf: [DominoValue]) -> Bool {
        !oneOf.filter { has(value: $0) }
            .isEmpty
    }
}
