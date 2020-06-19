//
//  GameView.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 31/05/2020.
//

import SnapKit
import UIKit

class GameView: UIView {
    let playerDominoes = DominoesView()
    let divider = UIView()
    let playerTrains: [DominoesView]

    var player1Train: DominoesView? {
        playerTrains[safe: 0]
    }

    var player2Train: DominoesView? {
        playerTrains[safe: 1]
    }

    var player3Train: DominoesView? {
        playerTrains[safe: 2]
    }

    var player4Train: DominoesView? {
        playerTrains[safe: 3]
    }

    init(frame: CGRect, numberOfTrains: Int) {
        playerTrains = (0 ..< numberOfTrains)
            .map { _ in DominoesView() }

        super.init(frame: frame)

        commonInit(numberOfTrains: numberOfTrains)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit(numberOfTrains: Int) {
        divider.backgroundColor = .darkGray

        addSubview(playerDominoes)
        addSubview(divider)
        playerTrains.forEach { addSubview($0) }

        playerDominoes.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(250)
        }

        divider.snp.makeConstraints { make in
            make.leading.trailing.equalTo(playerDominoes)
            make.top.equalTo(playerDominoes.snp.bottom)
            make.height.equalTo(2)
        }

        var previousView: UIView = divider
        playerTrains.forEach {
            $0.snp.makeConstraints { make in
                make.height.leading.trailing.equalTo(playerDominoes)
                make.top.equalTo(previousView.snp.bottom)
            }

            previousView = $0
        }

        previousView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
