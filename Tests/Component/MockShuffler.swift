//
//  MockShuffler.swift
//  Tests
//
//  Created by Home on 10/05/2020.
//

import Foundation

@testable import MexicanTrain

class MockShuffler: Shuffler {
    func shuffle<T>(_ data: [T]) -> [T] {
        data.reversed()
    }
}
