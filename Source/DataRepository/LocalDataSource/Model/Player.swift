//
//  Player.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct Player {
    let id: Int
    let name: String
    let dominoes: [Domino]
    let train: Train
}

extension Player {
    var pointsValue: Int {
        dominoes.map { $0.pointsValue }
            .reduce(0, +)
    }

    func with(name: String? = nil, dominoes: [Domino]? = nil, train: Train? = nil) -> Player {
        Player(id: id,
               name: name ?? self.name,
               dominoes: dominoes ?? self.dominoes,
               train: train ?? self.train)
    }

    func with(domino: Domino) -> Player {
        with(dominoes: dominoes.with(domino))
    }

    func without(domino: Domino) -> Player? {
        guard let dominoes = dominoes.without(domino) else {
            return nil
        }
        return with(dominoes: dominoes)
    }
}
