//
//  DominoCollectionViewLayout.swift
//  MexicanTrain
//
//  Created by Ceri Hughes on 27/06/2020.
//

import UIKit

class DominoCollectionViewLayout: UICollectionViewLayout {
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
        contentHeight = layoutAttributes.reduce(CGFloat(0)) { max($0, $1.bounds.maxY) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[safe: indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { rect.intersects($0.frame) }
    }
}

private extension DominoCollectionViewLayout.Placement {
    private static func p(_ x: Int, _ y: Int, _ direction: Direction) -> DominoCollectionViewLayout.Placement {
        DominoCollectionViewLayout.Placement(x: x, y: y, direction: direction)
    }

    private static let placement0 = DominoCollectionViewLayout.Placement.p(3, 0, .down) // Special case for index 0
    private static let placements: [DominoCollectionViewLayout.Placement] = [
        .p(3, 2, .right),
        .p(4, 1, .right),
        .p(5, 2, .right),
        .p(6, 1, .right),
        .p(7, 2, .down),
        .p(6, 3, .down),
        .p(7, 4, .down),
        .p(6, 5, .left),
        .p(5, 4, .left),
        .p(4, 5, .left),
        .p(3, 4, .left),
        .p(2, 5, .left),
        .p(1, 4, .left),
        .p(0, 5, .down),
        .p(1, 6, .down),
        .p(0, 7, .down),
        .p(1, 8, .right),
        .p(2, 7, .right)
    ]

    private func applyingRowOffset(_ rowOffset: Int) -> DominoCollectionViewLayout.Placement {
        DominoCollectionViewLayout.Placement(x: x, y: y + rowOffset, direction: direction)
    }

    static func placement(for index: Int) -> DominoCollectionViewLayout.Placement {
        if index == 0 { return .placement0 }

        let numberOfPlacements = DominoCollectionViewLayout.Placement.placements.count
        var arrayIndex = index - 1
        var rowOffset = 0

        while arrayIndex >= numberOfPlacements {
            arrayIndex -= numberOfPlacements
            rowOffset += 6
        }

        return DominoCollectionViewLayout.Placement.placements[arrayIndex].applyingRowOffset(rowOffset)
    }

    func toLayoutAttributes(index: Int, width: CGFloat) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
        let frame = toRect(width: width)
        attributes.frame = frame
        attributes.transform = toTransform(size: frame.size)
        return attributes
    }

    private func toRect(width: CGFloat) -> CGRect {
        let origin = CGPoint(x: CGFloat(x) * width / 8.0, y: CGFloat(y) * width / 8.0)
        let size = CGSize(width: width / 8.0, height: width / 4.0)
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

private extension CGAffineTransform {
    static func rotationAround(angle: CGFloat, size: CGSize) -> CGAffineTransform {
        let y = size.height * -0.25
        return CGAffineTransform(translationX: 0, y: y)
            .rotated(by: angle)
            .translatedBy(x: 0, y: -y)
    }
}

private extension Int {
    func toPlacement() -> DominoCollectionViewLayout.Placement {
        DominoCollectionViewLayout.Placement.placement(for: self)
    }
}
