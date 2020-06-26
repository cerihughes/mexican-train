//
//  Array+Extensions.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    @inlinable func anySatisfies(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        for item in self {
            if try predicate(item) {
                return true
            }
        }
        return false
    }
}

extension Array where Element: Equatable {
    func with(_ element: Element) -> [Element] {
        self + [element]
    }

    func without(_ element: Element) -> [Element]? {
        guard let firstIndex = firstIndex(of: element) else {
            return nil
        }
        var array = self
        _ = array.remove(at: firstIndex)
        return array
    }

    func removing(_ element: Element) -> [Element] {
        guard let firstIndex = firstIndex(of: element) else {
            return self
        }
        var array = self
        _ = array.remove(at: firstIndex)
        return array
    }
}
