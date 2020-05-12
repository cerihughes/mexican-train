//
//  DominoesView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

class DominoesView: UIView {
    let domino = DominoView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        addSubview(domino)

        domino.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 216, height: 115))
        }
    }
}
