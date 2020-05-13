//
//  SuperView.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 13/05/2020.
//

import UIKit

class SuperView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {}
}
