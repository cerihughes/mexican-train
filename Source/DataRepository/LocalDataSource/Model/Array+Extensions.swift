//
//  Array+Extensions.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

public extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array where Element: Equatable {
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
}
