//
//  DominoesView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

class DominoesView: SuperView {
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

        let newLayout = UICollectionViewFlowLayout.create(itemHeight: collectionView.frame.height)
        collectionView.setCollectionViewLayout(newLayout, animated: true)
    }
}

private extension UICollectionView {
    static func create() -> UICollectionView {
        let layout = UICollectionViewFlowLayout.create()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}

private extension UICollectionViewFlowLayout {
    static func create(itemHeight: CGFloat = 0.0) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemHeight * DominoView.aspectRatio, height: itemHeight)
        layout.minimumInteritemSpacing = DominoView.spacing
        layout.scrollDirection = .horizontal
        return layout
    }
}
