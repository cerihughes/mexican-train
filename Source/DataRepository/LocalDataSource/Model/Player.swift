//
//  Player.swift
//  MexicanTrain
//
//  Created by Home on 10/05/2020.
//

import Foundation

struct Player {
    let id: Int
    let name: String
    let dominoes: [Domino]
    let train: [Domino]
}

extension Player {
    var pointsValue: Int {
        dominoes.map { $0.pointsValue }
            .reduce(0, +)
    }

    func with(name: String? = nil, dominoes: [Domino]? = nil, train: [Domino]? = nil) -> Player {
        Player(id: id,
               name: name ?? self.name,
               dominoes: dominoes ?? self.dominoes,
               train: train ?? self.train)
    }

    func with(domino: Domino) -> Player {
        with(dominoes: dominoes + [domino])
    }
}
