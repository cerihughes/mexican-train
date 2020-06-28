//
//  DominoesView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

class DominoesView: SuperView {
    enum Mode {
        case unplayed, played
    }

    let collectionView = UICollectionView.create(mode: .unplayed)
    let trainButton = UIButton(type: .roundedRect)

    var mode: Mode = .unplayed {
        didSet {
            setNeedsLayout()
        }
    }

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

        let newLayout = mode.createCollectionViewLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: true)
    }
}

private extension DominoesView.Mode {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        switch self {
        case .unplayed:
            return UnplayedDominoCollectionViewLayout()
        case .played:
            return PlayedDominoCollectionViewLayout()
        }
    }
}

private extension UICollectionView {
    static func create(mode: DominoesView.Mode) -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: mode.createCollectionViewLayout())
    }
}
