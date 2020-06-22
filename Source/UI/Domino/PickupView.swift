//
//  PickupView.swift
//  MexicanTrain
//
//  Created by Ceri on 19/06/2020.
//

import UIKit

class PickupView: SuperView {
    private let label = UILabel()

    override func commonInit() {
        super.commonInit()

        backgroundColor = .white

        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.text = "+"

        layer.borderWidth = 8
        layer.cornerRadius = 16
        layer.borderColor = UIColor.black.cgColor

        addSubview(label)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
