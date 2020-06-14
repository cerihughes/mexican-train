//
//  Operations.swift
//  MexicanTrain
//
//  Created by Home on 13/06/2020.
//

import Foundation

class Operations {
    let changeTrain: ChangeTrainPlayableStateOperation
    let joinGame: JoinGameOperation
    let pass: PassOperation
    let pickUp: PickUpOperation
    let playOnMexicanTrain: PlaceDominoOnMexicanTrainOperation
    let playOnPlayer: PlaceDominoOnPlayerOperation
    let setup: SetupGameOperation

    init(ruleSet: RuleSet, shuffler: Shuffler) {
        changeTrain = ChangeTrainPlayableStateOperation()
        joinGame = JoinGameOperation(shuffler: shuffler)
        pass = PassOperation(ruleSet: ruleSet)
        pickUp = PickUpOperation(ruleSet: ruleSet, shuffler: shuffler)
        playOnMexicanTrain = PlaceDominoOnMexicanTrainOperation(ruleSet: ruleSet)
        playOnPlayer = PlaceDominoOnPlayerOperation(ruleSet: ruleSet)
        setup = SetupGameOperation(shuffler: shuffler)
    }
}
