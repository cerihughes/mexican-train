//
//  GameCoder.swift
//  MexicanTrain
//
//  Created by ceri on 12/06/2020.
//

import Foundation

class GameCoder {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func encode(_ game: Game) -> Data? {
        try? encoder.encode(game)
    }

    func decode(_ data: Data) -> Game? {
        try? decoder.decode(Game.self, from: data)
    }
}
