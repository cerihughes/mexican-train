//
//  DominoesView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

class DominoesView: SuperView {
    let domino = DominoView()

    override func commonInit() {
        super.commonInit()

        backgroundColor = .white

        addSubview(domino)

        domino.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 115, height: 216))
        }
    }
}
