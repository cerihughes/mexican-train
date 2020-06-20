//
//  PlayerData.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct PlayerData: Equatable, Codable {
    let id: String
    let dominoes: [UnplayedDomino]
    let train: Train

    private enum CodingKeys: String, CodingKey {
        case id
        case dominoes = "d"
        case train = "t"
    }
}

extension PlayerData {
    var pointsValue: Int {
        dominoes.map { $0.pointsValue }
            .reduce(0, +)
    }

    func with(dominoes: [UnplayedDomino]? = nil, train: Train? = nil) -> PlayerData {
        PlayerData(id: id,
                   dominoes: dominoes ?? self.dominoes,
                   train: train ?? self.train)
    }

    func with(domino: UnplayedDomino, train: Train? = nil) -> PlayerData {
        with(dominoes: dominoes.with(domino), train: train)
    }

    func without(domino: UnplayedDomino) -> PlayerData? {
        guard let dominoes = dominoes.without(domino) else {
            return nil
        }
        return with(dominoes: dominoes)
    }

    func canPlayOn(train: Train) -> Bool {
        if self.train == train {
            return true
        }

        guard self.train.isStarted else {
            return false
        }

        return train.isPlayable
    }
}
