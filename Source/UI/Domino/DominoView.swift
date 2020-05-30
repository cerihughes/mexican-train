//
//  DominoView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import SnapKit
import UIKit

class DominoView: SuperView {
    enum State: Equatable {
        case faceUp(DominoFaceView.Value, DominoFaceView.Value)
        case faceDown
    }

    private let face1 = DominoFaceView()
    private let face2 = DominoFaceView()

    var state: State = .faceDown {
        didSet {
            updateState()
        }
    }

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

    private func updateState() {
        let hiddenFaces: Bool
        if case let State.faceUp(face1Value, face2Value) = state {
            hiddenFaces = false
            face1.value = face1Value
            face2.value = face2Value
        } else {
            hiddenFaces = true
        }

        [face1, face2].forEach { $0.isHidden = hiddenFaces }
    }
}
