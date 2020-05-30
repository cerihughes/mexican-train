//
//  DominoesViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import UIKit

class DominoesViewController: UIViewController {
    private lazy var dominoesView = DominoesView()
    private var faceValues = DominoFaceView.Value.createData()

    override func loadView() {
        view = dominoesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dominoesView.collectionView.register(DominoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        dominoesView.collectionView.dataSource = self
        dominoesView.collectionView.delegate = self
    }
}

private let cellIdentifier = String(describing: DominoCollectionViewCell.self)

extension DominoesViewController: UICollectionViewDataSource {
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

extension DominoesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates({
            faceValues.remove(at: indexPath.row)
            dominoesView.collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
}

private extension DominoFaceView.Value {
    static func createData() -> [DominoFaceView.Value] {
        return (0 ... 12).compactMap { DominoFaceView.Value(rawValue: $0) }
    }
}
