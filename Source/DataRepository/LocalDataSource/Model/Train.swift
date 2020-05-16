//
//  Train.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

struct Train {
    let playable: Bool
    let dominoes: [Domino]
}

extension Train {
    func with(playable: Bool? = nil, dominoes: [Domino]? = nil) -> Train {
        Train(playable: playable ?? self.playable,
              dominoes: dominoes ?? self.dominoes)
    }

    func with(domino: Domino) -> Train {
        with(dominoes: dominoes.with(domino))
    }
}
