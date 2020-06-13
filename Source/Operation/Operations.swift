//
//  Operations.swift
//  MexicanTrain
//
//  Created by Home on 13/06/2020.
//

import Foundation

class Operations {
    let addPlayer: AddPlayerOperation
    let changeTrain: ChangeTrainPlayableStateOperation
    let pass: PassOperation
    let pickUp: PickUpOperation
    let playOnMexicanTrain: PlaceDominoOnMexicanTrainOperation
    let playOnPlayer: PlaceDominoOnPlayerOperation
    let setup: SetupGameOperation

    init(ruleSet: RuleSet, shuffler: Shuffler) {
        addPlayer = AddPlayerOperation(shuffler: shuffler)
        changeTrain = ChangeTrainPlayableStateOperation()
        pass = PassOperation(ruleSet: ruleSet)
        pickUp = PickUpOperation(ruleSet: ruleSet, shuffler: shuffler)
        playOnMexicanTrain = PlaceDominoOnMexicanTrainOperation(ruleSet: ruleSet)
        playOnPlayer = PlaceDominoOnPlayerOperation(ruleSet: ruleSet)
        setup = SetupGameOperation(shuffler: shuffler)
    }
}
