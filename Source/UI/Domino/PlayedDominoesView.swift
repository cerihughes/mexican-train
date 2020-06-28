//
//  PlayedDominoesView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

class PlayedDominoesView: SuperView {
    let collectionView = UICollectionView.create()
    let trainButton = UIButton(type: .roundedRect)

    override func commonInit() {
        super.commonInit()

        backgroundColor = .white
        collectionView.backgroundColor = .white

        trainButton.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        trainButton.titleLabel?.textColor = .black
        trainButton.setTitle("*", for: .normal)
        trainButton.isHidden = true

        addSubview(collectionView)
        addSubview(trainButton)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        trainButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let newLayout = PlayedDominoCollectionViewLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: true)
    }
}

private extension UICollectionView {
    static func create() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: PlayedDominoCollectionViewLayout())
    }
}
