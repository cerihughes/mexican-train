//
//  DominoesViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import UIKit

class DominoesViewController: UIViewController {
    private lazy var dominoesView = DominoesView()
    private var faceValues = [DominoFaceView.Value]()
    private var dataSource: DominoesCollectionViewDataSource?

    override func loadView() {
        view = dominoesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        DominoesCollectionViewDataSource.registerCells(in: dominoesView.collectionView)

        updateDominoes()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        dominoesView.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func tapped() {
        let numericValue = faceValues.last?.rawValue ?? 0
        faceValues.append(DominoFaceView.Value(rawValue: numericValue + 1) ?? .zero)
        updateDominoes()
    }

    private func updateDominoes() {
        let dominoStates = faceValues.map { DominoView.State.faceUp($0, $0) }
        dataSource = DominoesCollectionViewDataSource(dominoStates: dominoStates)
        dominoesView.collectionView.dataSource = dataSource
        dominoesView.collectionView.reloadData()
    }
}
