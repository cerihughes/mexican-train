//
//  DominoView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

class DominoView: SuperView {
    let face1 = DominoFaceView()
    let face2 = DominoFaceView()

    override func commonInit() {
        super.commonInit()

        layer.borderWidth = 8
        layer.cornerRadius = 16
        layer.borderColor = UIColor.black.cgColor

        addSubview(face1)
        addSubview(face2)

        face1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(face1.snp.height)
        }

        face2.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(face2.snp.height)
        }
    }
}
