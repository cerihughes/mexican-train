//
//  DominoFaceView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import UIKit

private let dotDataArray: [[UInt8]] = [
    [], // 0
    [0b001, 0b000, 0b100], // 2
    [0b101, 0b000, 0b101], // 4
    [0b101, 0b101, 0b101], // 6
    [0b111, 0b101, 0b111], // 8
    [0b111, 0b101, 0b101, 0b111], // 10
    [0b111, 0b111, 0b111, 0b111] // 12
]

class DominoFaceView: SuperView {
    enum Value: Int {
        case zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve
    }

    var value: Value = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    override func commonInit() {
        super.commonInit()

        backgroundColor = .white
        clipsToBounds = false
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setFillColor(value.color.cgColor)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(2)

        let size = bounds.size
        let dotDiameter = min(size.width, size.height) / 7.0
        let insetSize = size.inset(by: dotDiameter)
        let rowCount = value.dotData.count
        for mask in value.dotData.enumerated() {
            drawDot(mask.element.hasLeftDot, ctx: ctx, size: insetSize, rowIndex: mask.offset, rowCount: rowCount, columnIndex: 0, dotDiameter: dotDiameter)
            drawDot(mask.element.hasMiddleDot, ctx: ctx, size: insetSize, rowIndex: mask.offset, rowCount: rowCount, columnIndex: 1, dotDiameter: dotDiameter)
            drawDot(mask.element.hasRightDot, ctx: ctx, size: insetSize, rowIndex: mask.offset, rowCount: rowCount, columnIndex: 2, dotDiameter: dotDiameter)
        }

        drawDot(value.hasCentralDot, ctx: ctx, size: insetSize, rowIndex: 1, rowCount: 3, columnIndex: 1, dotDiameter: dotDiameter)
    }

    private func drawDot(_ visible: Bool,
                         ctx: CGContext,
                         size: CGSize,
                         rowIndex: Int,
                         rowCount: Int,
                         columnIndex: Int,
                         dotDiameter: CGFloat) {
        guard visible == true, rowCount > 1 else { return }

        let verticalSpacing = size.height / CGFloat(rowCount - 1)
        let horizontalSpacing = size.width / 2.0
        let centerPoint = CGPoint(x: horizontalSpacing * CGFloat(columnIndex),
                                  y: verticalSpacing * CGFloat(rowIndex))
            .offset(by: dotDiameter)
        drawDot(ctx: ctx, centerPoint: centerPoint, dotDiameter: dotDiameter)
    }

    private func drawDot(ctx: CGContext, centerPoint: CGPoint, dotDiameter: CGFloat) {
        let dotRadius = dotDiameter / 2.0
        let rect = CGRect(x: centerPoint.x - dotRadius,
                          y: centerPoint.y - dotRadius,
                          width: dotDiameter,
                          height: dotDiameter)
        ctx.addEllipse(in: rect)
        ctx.drawPath(using: .fillStroke)
    }
}

private extension DominoFaceView.Value {
    private var dotDataIndex: Int {
        let float = Float(rawValue) / 2.0
        let floored = floor(float)
        return Int(floored)
    }

    var dotData: [UInt8] {
        let index = dotDataIndex
        return dotDataArray[safe: index] ?? []
    }

    var hasCentralDot: Bool {
        return rawValue % 2 == 1
    }

    var color: UIColor {
        switch self {
        case .zero:
            return .clear
        case .one:
            return .blue
        case .two:
            return .yellow
        case .three:
            return .brown
        case .four:
            return .lightGray
        case .five:
            return .orange
        case .six:
            return .white
        case .seven:
            return .cyan
        case .eight:
            return .red
        case .nine:
            return .magenta
        case .ten:
            return .darkGray
        case .eleven:
            return .green
        case .twelve:
            return .purple
        }
    }
}

private extension CGSize {
    mutating func applyInset(_ value: CGFloat) {
        width -= value * 2.0
        height -= value * 2.0
    }

    func inset(by value: CGFloat) -> CGSize {
        var size = self
        size.applyInset(value)
        return size
    }
}

private extension CGPoint {
    mutating func applyOffset(_ value: CGFloat) {
        x += value
        y += value
    }

    func offset(by value: CGFloat) -> CGPoint {
        var point = self
        point.applyOffset(value)
        return point
    }
}

private extension UInt8 {
    private static let leftDot: UInt8 = 0b100
    private static let middleDot: UInt8 = 0b010
    private static let rightDot: UInt8 = 0b001

    var hasLeftDot: Bool {
        return self & .leftDot == .leftDot
    }

    var hasMiddleDot: Bool {
        return self & .middleDot == .middleDot
    }

    var hasRightDot: Bool {
        return self & .rightDot == .rightDot
    }
}
