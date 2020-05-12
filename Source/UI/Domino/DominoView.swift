//
//  DominoView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

class DominoView: UIView {
    let face1 = DominoFaceView()
    let face2 = DominoFaceView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        layer.borderWidth = 8
        layer.cornerRadius = 16
        layer.borderColor = UIColor.black.cgColor
    }
}
