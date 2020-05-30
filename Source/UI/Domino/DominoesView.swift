//
//  DominoesView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

private let dominoWidth = 115.0
private let dominoHeight = 216.0
private let dimensionRatio = dominoHeight / dominoWidth
private let dominoSize = CGSize(width: dominoWidth, height: dominoHeight)
private let dominoFrame = CGRect(origin: .zero, size: dominoSize)

class DominoesView: SuperView {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var dominoStates = [DominoView.State]()

    override func commonInit() {
        super.commonInit()

        backgroundColor = .white

        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 8.0

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(dominoHeight)
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(dominoHeight)
        }
    }

    func add(state: DominoView.State) {
        let dominoView = DominoView()
        dominoView.state = state
        dominoView.snp.makeConstraints { make in
            make.size.equalTo(dominoSize)
            make.height.equalTo(dominoView.snp.width).multipliedBy(dimensionRatio)
        }

        stackView.addArrangedSubview(dominoView)
        scrollView.scrollRectToVisible(scrollView.rightmostRect, animated: true)
    }

    func remove(state: DominoView.State) {
        let views = stackView.arrangedSubviews.compactMap { $0 as? DominoView }
            .filter { $0.state == state }
        views.forEach { $0.removeFromSuperview() }
    }
}

private extension UIScrollView {
    var rightmostRect: CGRect {
        return CGRect(x: contentSize.width - 1, y: 1, width: 1, height: 1)
    }
}
