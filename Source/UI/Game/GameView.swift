//
//  GameView.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 31/05/2020.
//

import SnapKit
import UIKit

class GameView: SuperView {
    let playerDominoes = DominoesView()
    let player1Train = DominoesView()
    let player2Train = DominoesView()

    override func commonInit() {
        addSubview(playerDominoes)
        addSubview(player1Train)
        addSubview(player2Train)

        playerDominoes.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(250)
        }

        player1Train.snp.makeConstraints { make in
            make.height.leading.trailing.equalTo(playerDominoes)
            make.top.equalTo(playerDominoes.snp.bottom)
        }

        player2Train.snp.makeConstraints { make in
            make.height.leading.trailing.equalTo(playerDominoes)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
