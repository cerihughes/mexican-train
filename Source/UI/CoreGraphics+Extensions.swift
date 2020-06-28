//
//  CoreGraphics+Extensions.swift
//  MexicanTrain
//
//  Created by Home on 28/06/2020.
//

import CoreGraphics

extension CGAffineTransform {
    static func rotationAround(angle: CGFloat, size: CGSize) -> CGAffineTransform {
        let y = size.height * -0.25
        return CGAffineTransform(translationX: 0, y: y)
            .rotated(by: angle)
            .translatedBy(x: 0, y: -y)
    }
}
