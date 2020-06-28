//
//  GameBoardView.swift
//  MexicanTrain
//
//  Created by Home on 28/06/2020.
//

import UIKit

private let unitWidth: CGFloat = 60.0
private let trainWidth = unitWidth * 15

class GameBoardView: UIView {
    private let centralView = UIView()
    let stationDominoView = DominoView()
    let mexicanTrain = PlayedDominoesView()
    let playerTrains: [PlayedDominoesView]

    init(frame: CGRect, numberOfTrains: Int) {
        playerTrains = (0 ..< numberOfTrains)
            .map { _ in PlayedDominoesView() }

        super.init(frame: frame)

        commonInit(numberOfTrains: numberOfTrains)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit(numberOfTrains: Int) {
        backgroundColor = .white
        centralView.backgroundColor = .gray

        centralView.addSubview(stationDominoView)
        addSubview(centralView)
        addSubview(mexicanTrain)
        playerTrains.forEach { addSubview($0) }

        stationDominoView.snp.makeConstraints { make in
            make.top.bottom.height.centerX.equalToSuperview()
            make.width.equalTo(stationDominoView.snp.height).dividedBy(2)
        }

        centralView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(unitWidth * 2)
        }

        ([mexicanTrain] + playerTrains)
            .enumerated()
            .forEach { [weak self] in self?.constrainView(view: $0.element, at: $0.offset) }
    }

    func indexOfTrainCollectionView(_ collectionView: UICollectionView) -> Int? {
        playerTrains.map { $0.collectionView }
            .firstIndex(of: collectionView)
    }

    private func constrainView(view: UIView, at index: Int) {
        switch index {
        case 0:
            constrainViewToBottom(view: view)
        case 1:
            constrainViewToLeading(view: view)
        case 2:
            constrainViewToTrailing(view: view)
        case 3:
            constrainViewToTop(view: view)
        default:
            break
        }
    }

    private func constrainViewToTop(view: UIView) {
        view.transform = CGAffineTransform(rotationAngle: .pi)
        view.snp.makeConstraints { make in
            make.width.height.equalTo(trainWidth)
            make.bottom.equalTo(centralView.snp.top)
            make.centerX.equalToSuperview()
        }
    }

    private func constrainViewToBottom(view: UIView) {
        view.snp.makeConstraints { make in
            make.width.height.equalTo(trainWidth)
            make.top.equalTo(centralView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }

    private func constrainViewToLeading(view: UIView) {
        view.transform = CGAffineTransform(rotationAngle: .pi / 2.0)
        view.snp.makeConstraints { make in
            make.width.height.equalTo(trainWidth)
            make.trailing.equalTo(centralView.snp.leading)
            make.centerY.equalToSuperview()
        }
    }

    private func constrainViewToTrailing(view: UIView) {
        view.transform = CGAffineTransform(rotationAngle: .pi / -2.0)
        view.snp.makeConstraints { make in
            make.width.height.equalTo(trainWidth)
            make.leading.equalTo(centralView.snp.trailing)
            make.centerY.equalToSuperview()
        }
    }
}
