//
//  LevelSummaryView.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import UIKit

class LevelSummaryView: SuperView {
    private let stackView = UIStackView()

    override func commonInit() {
        backgroundColor = .white
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
