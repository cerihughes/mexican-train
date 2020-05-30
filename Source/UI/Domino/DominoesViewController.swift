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

    override func loadView() {
        view = dominoesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dominoesView.collectionView.register(DominoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        dominoesView.collectionView.dataSource = self

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        dominoesView.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func tapped() {
        dominoesView.collectionView.performBatchUpdates(addDomino, completion: nil)
    }

    private func addDomino() {
        let numericValue = faceValues.first?.rawValue ?? 0
        faceValues.insert(DominoFaceView.Value(rawValue: numericValue + 1) ?? .zero, at: 0)
        dominoesView.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
    }
}

private let cellIdentifier = String(describing: DominoCollectionViewCell.self)

extension DominoesViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        faceValues.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        if let dominoCell = cell as? DominoCollectionViewCell, let faceValue = faceValue(for: indexPath) {
            dominoCell.dominoView.state = .faceUp(faceValue, faceValue)
        }
        return cell
    }

    private func faceValue(for indexPath: IndexPath) -> DominoFaceView.Value? {
        let index = indexPath.row
        guard faceValues.indices.contains(index) else {
            return nil
        }
        return faceValues[index]
    }
}
