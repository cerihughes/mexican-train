//
//  DominoesViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import UIKit

class DominoesViewController: UIViewController {
    private lazy var dominoesView = DominoesView()

    override func loadView() {
        view = dominoesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        dominoesView.domino.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func tapped() {
        let numericValue = dominoesView.domino.face1.value.rawValue
        let nextValue = DominoFaceView.Value(rawValue: numericValue + 1) ?? .zero
        dominoesView.domino.face1.value = nextValue
        dominoesView.domino.face2.value = nextValue
    }
}
