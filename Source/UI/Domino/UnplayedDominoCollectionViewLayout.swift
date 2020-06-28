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

    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
    }

    private var contentWidth: CGFloat = 0

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let contentHeight = self.contentHeight
        let layoutAttributes = (0 ..< collectionView.numberOfItems(inSection: 0))
            .map { $0.toPlacement() }
            .enumerated()
            .map { $0.element.toLayoutAttributes(index: $0.offset, height: contentHeight) }

        cache = layoutAttributes
        contentWidth = layoutAttributes.reduce(CGFloat(0)) { max($0, $1.frame.maxX) }
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
        return UnplayedDominoCollectionViewLayout.Placement(x: index, y: index % 2)
    }

    func toLayoutAttributes(index: Int, height: CGFloat) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
        let frame = toRect(height: height)
        attributes.frame = frame
        attributes.transform = toTransform(size: frame.size)
        return attributes
    }

    private func toRect(height: CGFloat) -> CGRect {
        let multiple = height / 2.0
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
