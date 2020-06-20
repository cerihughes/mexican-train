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
    let label = UILabel()

    override func commonInit() {
        super.commonInit()

        backgroundColor = .white
        collectionView.backgroundColor = .white

        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.text = "*"
        label.isHidden = true

        addSubview(collectionView)
        addSubview(label)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        label.snp.makeConstraints { make in
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
