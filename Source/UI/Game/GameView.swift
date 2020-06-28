//
//  GameView.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import SnapKit
import UIKit

class GameView: UIView {
    let pickupView = PickupView()
    let playerDominoes = UnplayedDominoesView()
    let divider = UIView()
    let boardView: GameBoardView

    init(frame: CGRect, numberOfTrains: Int) {
        boardView = GameBoardView(frame: .zero, numberOfTrains: numberOfTrains)

        super.init(frame: frame)

        commonInit(numberOfTrains: numberOfTrains)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit(numberOfTrains: Int) {
        backgroundColor = .white
        divider.backgroundColor = .darkGray

        addSubview(pickupView)
        addSubview(playerDominoes)
        addSubview(divider)
        addSubview(boardView)

        pickupView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.bottom.equalTo(playerDominoes).inset(8)
            make.width.equalTo(pickupView.snp.height).dividedBy(2)
        }

        playerDominoes.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(124)
            make.leading.equalTo(pickupView.snp.trailing).offset(8)
        }

        divider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(playerDominoes.snp.bottom)
            make.height.equalTo(2)
        }

        boardView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(divider)
            make.top.equalTo(divider.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
