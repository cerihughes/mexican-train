//
//  RuleSet.swift
//  MexicanTrain
//
//  Created by Ceri on 16/05/2020.
//

import Foundation

protocol RuleSet {
    func currentPlayerHasValidPlay(in gameState: GameState) -> Bool
    func player(_ player: PlayerData, canPlay domino: UnplayedDomino, on train: Train, in gameState: GameState) -> Bool
}
