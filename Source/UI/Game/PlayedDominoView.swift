//
//  PlayedDominoView.swift
//  MexicanTrain
//
//  Created by Home on 28/06/2020.
//

import UIKit

class UnplayedDominoView: SuperView {
    let collectionView = UICollectionView.create()

    override func commonInit() {
        super.commonInit()

        backgroundColor = .white
        collectionView.backgroundColor = .white

        addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
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
