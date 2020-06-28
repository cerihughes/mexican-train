//
//  UnplayedDominoCollectionViewLayout.swift
//  MexicanTrain
//
//  Created by Home on 28/06/2020.
//

import UIKit

class UnplayedDominoCollectionViewLayout: UICollectionViewLayout {
    fileprivate struct Placement {
        let x: Int
        let y: Int
    }

    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }

    private var contentHeight: CGFloat = 0

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let contentWidth = self.contentWidth
        let layoutAttributes = (0 ..< collectionView.numberOfItems(inSection: 0))
            .map { $0.toPlacement() }
            .enumerated()
            .map { $0.element.toLayoutAttributes(index: $0.offset, width: contentWidth) }

        cache = layoutAttributes
        contentHeight = layoutAttributes.reduce(CGFloat(0)) { max($0, $1.bounds.maxY) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[safe: indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { rect.intersects($0.frame) }
    }
}

private extension UnplayedDominoCollectionViewLayout.Placement {
    static func placement(for index: Int) -> UnplayedDominoCollectionViewLayout.Placement {
        let numberOfPlacements = 10
        var columnIndex = index
        var rowOffset = 0

        while columnIndex >= numberOfPlacements {
            columnIndex -= numberOfPlacements
            rowOffset += 2
        }

        return UnplayedDominoCollectionViewLayout.Placement(x: columnIndex, y: (columnIndex % 2) + rowOffset)
    }

    func toLayoutAttributes(index: Int, width: CGFloat) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
        let frame = toRect(width: width)
        attributes.frame = frame
        attributes.transform = toTransform(size: frame.size)
        return attributes
    }

    private func toRect(width: CGFloat) -> CGRect {
        let multiple = width / 11.0
        let origin = CGPoint(x: CGFloat(x) * multiple, y: CGFloat(y) * multiple)
        let size = CGSize(width: multiple, height: multiple * 2.0)
        return CGRect(origin: origin, size: size)
    }

    private func toTransform(size: CGSize) -> CGAffineTransform {
        .rotationAround(angle: .pi / -2.0, size: size)
    }
}

private extension Int {
    func toPlacement() -> UnplayedDominoCollectionViewLayout.Placement {
        UnplayedDominoCollectionViewLayout.Placement.placement(for: self)
    }
}
