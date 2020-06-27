//
//  GameView.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 31/05/2020.
//

import SnapKit
import UIKit

class GameView: UIView {
    let pickupView = PickupView()
    let playerDominoes = DominoesView()
    let divider = UIView()
    let mexicanTrain = DominoesView()
    let playerTrains: [DominoesView]

    init(frame: CGRect, numberOfTrains: Int) {
        playerTrains = (0 ..< numberOfTrains)
            .map { _ in
                let view = DominoesView()
                view.mode = .played
                return view
            }

        super.init(frame: frame)

        commonInit(numberOfTrains: numberOfTrains)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit(numberOfTrains: Int) {
        backgroundColor = .white
        divider.backgroundColor = .darkGray

        playerDominoes.mode = .unplayed
        mexicanTrain.mode = .played

        addSubview(pickupView)
        addSubview(playerDominoes)
        addSubview(divider)
        addSubview(mexicanTrain)
        playerTrains.forEach { addSubview($0) }

        pickupView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(DominoView.spacing)
            make.bottom.equalTo(playerDominoes).inset(DominoView.spacing)
            make.width.equalTo(pickupView.snp.height).multipliedBy(DominoView.aspectRatio)
        }

        playerDominoes.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(pickupView.snp.trailing).offset(DominoView.spacing)
        }

        divider.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(playerDominoes.snp.bottom)
            make.height.equalTo(2)
        }

        mexicanTrain.snp.makeConstraints { make in
            make.leading.trailing.equalTo(divider)
            make.top.equalTo(divider.snp.bottom)
            make.height.equalTo(playerDominoes)
        }

        var previousView: UIView = mexicanTrain
        playerTrains.forEach {
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalTo(previousView)
                make.top.equalTo(previousView.snp.bottom)
                make.height.equalTo(playerDominoes)
            }

            previousView = $0
        }

        previousView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    func indexOfTrainCollectionView(_ collectionView: UICollectionView) -> Int? {
        playerTrains.map { $0.collectionView }
            .firstIndex(of: collectionView)
    }
}
