//
//  Operations.swift
//  MexicanTrain
//
//  Created by Ceri on 13/06/2020.
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

    init(shuffler: Shuffler) {
        changeTrain = ChangeTrainPlayableStateOperation()
        joinGame = JoinGameOperation(shuffler: shuffler)
        pass = PassOperation()
        pickUp = PickUpOperation(shuffler: shuffler)
        playOnMexicanTrain = PlaceDominoOnMexicanTrainOperation()
        playOnPlayer = PlaceDominoOnPlayerOperation()
        setup = SetupGameOperation(shuffler: shuffler)
    }
}
