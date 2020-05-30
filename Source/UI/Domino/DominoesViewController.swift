//
//  DominoesViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import UIKit

class DominoesViewController: UIViewController {
    private lazy var dominoesView = DominoesView()
    private var faceValue = DominoFaceView.Value.zero

    override func loadView() {
        view = dominoesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateDominoes()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        dominoesView.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func tapped() {
        let numericValue = faceValue.rawValue
        faceValue = DominoFaceView.Value(rawValue: numericValue + 1) ?? .zero
        updateDominoes()
    }

    private func updateDominoes() {
        let state = DominoView.State.faceUp(faceValue, faceValue)
        dominoesView.remove(state: state)
        dominoesView.add(state: state)
    }
}
