//
//  Train.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

struct Train: Hashable {
    let isPlayable: Bool
    let dominoes: [PlayedDomino]
}

extension Train {
    var isStarted: Bool {
        !dominoes.isEmpty
    }

    var playableValue: DominoValue? {
        dominoes.last?.outerValue
    }

    func with(isPlayable: Bool? = nil, dominoes: [PlayedDomino]? = nil) -> Train {
        Train(isPlayable: isPlayable ?? self.isPlayable,
              dominoes: dominoes ?? self.dominoes)
    }

    func with(domino: PlayedDomino) -> Train {
        with(dominoes: dominoes.with(domino))
    }
}
