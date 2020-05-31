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
    let player2Dominoes = DominoesView()

    override func commonInit() {
        addSubview(player1Dominoes)
        addSubview(player2Dominoes)

        player1Dominoes.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(250)
        }

        player2Dominoes.snp.makeConstraints { make in
            make.height.equalTo(player1Dominoes)
            make.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
}
