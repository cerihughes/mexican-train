//
//  RuleSet.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

protocol RuleSet {
    func currentPlayerHasValidPlay(in game: Game) -> Bool
    func player(_ player: Player, canPlay domino: Domino, on train: [Domino], in game: Game) -> Bool
}
