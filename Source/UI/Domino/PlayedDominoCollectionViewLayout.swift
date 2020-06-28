//
//  PlayedDominoCollectionViewLayout.swift
//  MexicanTrain
//
//  Created by Ceri on 27/06/2020.
//

import UIKit

class PlayedDominoCollectionViewLayout: UICollectionViewLayout {
    fileprivate struct Placement {
        enum Direction {
            case right, down, left
        }

        let x: Int
        let y: Int
        let direction: Direction
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
        contentHeight = layoutAttributes.reduce(CGFloat(0)) { max($0, $1.frame.maxY) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[safe: indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { rect.intersects($0.frame) }
    }
}

private extension PlayedDominoCollectionViewLayout.Placement {
    private static func p(_ x: Int, _ y: Int, _ direction: Direction) -> PlayedDominoCollectionViewLayout.Placement {
        PlayedDominoCollectionViewLayout.Placement(x: x, y: y, direction: direction)
    }

    private static let placements: [PlayedDominoCollectionViewLayout.Placement] = [
        .p(7, 0, .down),
        .p(7, 2, .right),
        .p(8, 1, .right),
        .p(9, 2, .down),
        .p(8, 3, .down),
        .p(9, 4, .down),
        .p(8, 5, .left),
        .p(7, 4, .left),
        .p(6, 5, .left),
        .p(5, 4, .left),
        .p(4, 5, .down),
        .p(5, 6, .down),
        .p(4, 7, .down),
        .p(5, 8, .right),
        .p(6, 7, .right),
        .p(7, 8, .right),
        .p(8, 7, .right),
        .p(9, 8, .right),
        .p(10, 7, .right),
        .p(11, 8, .right),
        .p(12, 7, .right),
        .p(13, 8, .down),
        .p(12, 9, .down),
        .p(13, 10, .down),
        .p(12, 11, .left),
        .p(11, 10, .left),
        .p(10, 11, .left),
        .p(9, 10, .left),
        .p(8, 11, .left),
        .p(7, 10, .left),
        .p(6, 11, .left),
        .p(5, 10, .left),
        .p(4, 11, .left),
        .p(3, 10, .left),
        .p(2, 11, .left)
    ]

    static func placement(for index: Int) -> PlayedDominoCollectionViewLayout.Placement {
        placements[safe: index] ?? .p(1, 10, .left)
    }

    func toLayoutAttributes(index: Int, width: CGFloat) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
        let frame = toRect(width: width)
        attributes.frame = frame
        attributes.transform = toTransform(size: frame.size)
        return attributes
    }

    private func toRect(width: CGFloat) -> CGRect {
        let multiple = width / 15.0
        let origin = CGPoint(x: CGFloat(x) * multiple, y: CGFloat(y) * multiple)
        let size = CGSize(width: multiple, height: multiple * 2.0)
        return CGRect(origin: origin, size: size)
    }

    private func toTransform(size: CGSize) -> CGAffineTransform {
        switch direction {
        case .down: return .identity
        case .left: return .rotationAround(angle: .pi / 2.0, size: size)
        case .right: return .rotationAround(angle: .pi / -2.0, size: size)
        }
    }
}

private extension Int {
    func toPlacement() -> PlayedDominoCollectionViewLayout.Placement {
        PlayedDominoCollectionViewLayout.Placement.placement(for: self)
    }
}
