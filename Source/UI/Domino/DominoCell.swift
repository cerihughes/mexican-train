//
//  DominoCell.swift
//  MexicanTrain
//
//  Created by Ceri on 30/05/2020.
//

import SnapKit
import UIKit

class DominoCell: UICollectionViewCell {
    let dominoView = DominoView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        contentView.addSubview(dominoView)

        dominoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
