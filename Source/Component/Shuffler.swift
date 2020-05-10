//
//  Shuffler.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

protocol Shuffler {
    func shuffle<T>(_ data: [T]) -> [T]
}

extension Shuffler {
    func randomElement<T>(_ data: [T]) -> T? {
        shuffle(data).first
    }
}

extension Array {
    func shuffled(using shuffler: Shuffler) -> [Element] {
        shuffler.shuffle(self)
    }

    func randomElement(using shuffler: Shuffler) -> Element? {
        shuffler.randomElement(self)
    }
}

extension Array where Element: Equatable {
    mutating func removeRandomElement(using shuffler: Shuffler) -> Element? {
        guard let element = randomElement(using: shuffler),
            let index = firstIndex(of: element) else {
            return nil
        }

        remove(at: index)
        return element
    }

    mutating func removeRandomElements(_ count: Int, using shuffler: Shuffler) -> [Element] {
        return (1 ... count)
            .compactMap { _ in removeRandomElement(using: shuffler) }
    }
}

class ShufflerImplementation: Shuffler {
    func shuffle<T>(_ data: [T]) -> [T] {
        data.shuffled()
    }
}
