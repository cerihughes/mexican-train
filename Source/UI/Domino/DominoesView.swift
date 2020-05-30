//
//  DominoesView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

private let dominoWidth = 115.0
private let dominoHeight = 216.0
private let dominoSize = CGSize(width: dominoWidth, height: dominoHeight)

class DominoesView: SuperView {
    let collectionView = UICollectionView.createCollectionView()

    override func commonInit() {
        super.commonInit()

        backgroundColor = .white
        collectionView.backgroundColor = .white

        addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(dominoHeight)
        }
    }
}

private extension UICollectionView {
    static func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = dominoSize
        layout.minimumInteritemSpacing = 8.0
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}
