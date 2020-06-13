//
//  Player.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct Player: Equatable, Codable {
    struct Details: Equatable, Codable {
        let id: String
        let name: String
    }

    let details: Details
    let dominoes: [UnplayedDomino]
    let train: Train
}

extension Player {
    var pointsValue: Int {
        dominoes.map { $0.pointsValue }
            .reduce(0, +)
    }

    func with(dominoes: [UnplayedDomino]? = nil, train: Train? = nil) -> Player {
        Player(details: details,
               dominoes: dominoes ?? self.dominoes,
               train: train ?? self.train)
    }

    func with(domino: UnplayedDomino) -> Player {
        with(dominoes: dominoes.with(domino))
    }

    func without(domino: UnplayedDomino) -> Player? {
        guard let dominoes = dominoes.without(domino) else {
            return nil
        }
        return with(dominoes: dominoes)
    }
}
