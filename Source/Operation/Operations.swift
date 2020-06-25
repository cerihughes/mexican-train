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
    let startLevel: StartLevelOperation

    init(gameEngine: GameEngine, shuffler: Shuffler) {
        changeTrain = ChangeTrainPlayableStateOperation(gameEngine: gameEngine)
        joinGame = JoinGameOperation(gameEngine: gameEngine)
        pass = PassOperation(gameEngine: gameEngine)
        pickUp = PickUpOperation(gameEngine: gameEngine, shuffler: shuffler)
        playOnMexicanTrain = PlaceDominoOnMexicanTrainOperation(gameEngine: gameEngine)
        playOnPlayer = PlaceDominoOnPlayerOperation(gameEngine: gameEngine)
        startLevel = StartLevelOperation(gameEngine: gameEngine, shuffler: shuffler)
    }
}
