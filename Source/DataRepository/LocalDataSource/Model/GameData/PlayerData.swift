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
    let currentTurn: [UnplayedDomino]
    let score: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case dominoes = "d"
        case train = "t"
        case currentTurn = "ct"
        case score = "s"
    }
}

extension PlayerData {
    var pointsValue: Int {
        dominoes.map { $0.pointsValue }
            .reduce(0, +)
    }

    func with(dominoes: [UnplayedDomino]? = nil, train: Train? = nil, currentTurn: [UnplayedDomino]? = nil, score: Int? = nil) -> PlayerData {
        PlayerData(id: id,
                   dominoes: dominoes ?? self.dominoes,
                   train: train ?? self.train,
                   currentTurn: currentTurn ?? self.currentTurn,
                   score: score ?? self.score)
    }

    func with(domino: UnplayedDomino, train: Train? = nil) -> PlayerData {
        with(dominoes: dominoes.with(domino), train: train)
    }

    func without(domino: UnplayedDomino) -> PlayerData? {
        guard let dominoes = dominoes.without(domino) else {
            return nil
        }
        var currentTurn = self.currentTurn
        currentTurn.append(domino)
        return with(dominoes: dominoes, currentTurn: currentTurn)
    }

    func canPlayOn(train: Train) -> Bool {
        if self.train == train {
            return true
        }

        guard self.train.isStarted else {
            return false
        }

        if let last = train.dominoes.last, last.isDouble {
            return true
        }

        return train.isPlayable
    }

    var hasPlayedDoubleInThisTurn: Bool {
        !currentTurn.isEmpty
    }
}
