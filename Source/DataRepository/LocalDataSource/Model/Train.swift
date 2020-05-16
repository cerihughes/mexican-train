//
//  Train.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

struct Train {
    let isPlayable: Bool
    let dominoes: [Domino]
}

extension Train {
    var isStarted: Bool {
        !dominoes.isEmpty
    }

    func with(isPlayable: Bool? = nil, dominoes: [Domino]? = nil) -> Train {
        Train(isPlayable: isPlayable ?? self.isPlayable,
              dominoes: dominoes ?? self.dominoes)
    }

    func with(domino: Domino) -> Train {
        with(dominoes: dominoes.with(domino))
    }
}
