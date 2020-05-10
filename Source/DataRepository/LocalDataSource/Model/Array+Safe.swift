//
//  Array+Safe.swift
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
