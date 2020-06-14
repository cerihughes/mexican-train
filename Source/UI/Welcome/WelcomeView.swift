//
//  WelcomeView.swift
//  MexicanTrain
//
//  Created by Ceri on 14/06/2020.
//

import SnapKit
import UIKit

class WelcomeView: SuperView {
    let label = UILabel.create()
    let button = UIButton.create()

    override func commonInit() {
        backgroundColor = .white

        addSubview(label)
        addSubview(button)

        label.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}

private extension UILabel {
    static func create() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        return label
    }
}

private extension UIButton {
    static func create() -> UIButton {
        UIButton(type: .system)
    }
}
