//
//  DominoesCollectionViewDataSource.swift
//  MexicanTrain
//
//  Created by Ceri on 30/05/2020.
//

import UIKit

private let cellIdentifier = String(describing: DominoCollectionViewCell.self)

class DominoesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private let dominoStates: [DominoView.State]

    init(dominoStates: [DominoView.State]) {
        self.dominoStates = dominoStates
        super.init()
    }

    static func registerCells(in collectionView: UICollectionView) {
        collectionView.register(DominoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dominoStates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        if let dominoCell = cell as? DominoCollectionViewCell, let state = dominoState(for: indexPath) {
            dominoCell.dominoView.state = state
        }
        return cell
    }

    private func dominoState(for indexPath: IndexPath) -> DominoView.State? {
        let index = indexPath.row
        guard dominoStates.indices.contains(index) else {
            return nil
        }
        return dominoStates[index]
    }
}
