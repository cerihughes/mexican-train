//
//  GameView.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 31/05/2020.
//

import SnapKit
import UIKit

class GameView: SuperView {
    let player1Dominoes = DominoesView()
    let player1Train = DominoesView()
    let player2Train = DominoesView()

    override func commonInit() {
        addSubview(player1Dominoes)
        addSubview(player1Train)
        addSubview(player2Train)

        player1Dominoes.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(250)
        }

        player1Train.snp.makeConstraints { make in
            make.height.leading.trailing.equalTo(player1Dominoes)
            make.top.equalTo(player1Dominoes.snp.bottom)
        }

        player2Train.snp.makeConstraints { make in
            make.height.leading.trailing.equalTo(player1Dominoes)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
