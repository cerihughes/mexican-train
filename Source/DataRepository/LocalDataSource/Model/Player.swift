//
//  Player.swift
//  MexicanTrain
//
//  Created by Ceri on 10/05/2020.
//

import Foundation

struct Player: Equatable, Codable {
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

extension Player {
    func with(dominoes: [UnplayedDomino]? = nil, train: Train? = nil, currentTurn: [UnplayedDomino]? = nil, score: Int? = nil) -> Player {
        Player(id: id,
               dominoes: dominoes ?? self.dominoes,
               train: train ?? self.train,
               currentTurn: currentTurn ?? self.currentTurn,
               score: score ?? self.score)
    }

    func with(domino: UnplayedDomino, train: Train? = nil) -> Player {
        with(dominoes: dominoes.with(domino), train: train)
    }

    func withUpdatedScore() -> Player {
        with(dominoes: [], score: score + pointsValue)
    }

    func without(domino: UnplayedDomino) -> Player? {
        guard let dominoes = dominoes.without(domino) else {
            return nil
        }
        var currentTurn = self.currentTurn
        currentTurn.append(domino)
        return with(dominoes: dominoes, currentTurn: currentTurn)
    }
}
