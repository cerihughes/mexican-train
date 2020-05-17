//
//  Domino.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct Domino: Equatable {
    enum Value: Int, CaseIterable {
        case zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve
    }

    let value1: Value
    let value2: Value
}

extension Domino {
    static func allDominoes() -> [Domino] {
        let allValues = Value.allCases
        guard let first = allValues.first?.rawValue, let last = allValues.last?.rawValue else {
            return []
        }

        var allDominoes = [Domino]()
        for value1 in first ... last {
            for value2 in value1 ... last {
                if let enum1 = Value(rawValue: value1), let enum2 = Value(rawValue: value2) {
                    allDominoes.append(Domino(value1: enum1, value2: enum2))
                }
            }
        }

        return allDominoes
    }
}

extension Domino {
    var pointsValue: Int {
        value1.rawValue + value2.rawValue
    }

    func has(value: Value) -> Bool {
        value1 == value || value2 == value
    }

    func isPlayable(with other: Domino) -> Bool {
        has(value: other.value1) || has(value: other.value2)
    }

    func isPlayable(with oneOf: [Domino]) -> Bool {
        !oneOf.filter { $0.isPlayable(with: self) }
            .isEmpty
    }
}
