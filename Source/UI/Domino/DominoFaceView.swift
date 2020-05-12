//
//  DominoFaceView.swift
//  MexicanTrain
//
//  Created by Ceri on 12/05/2020.
//

import UIKit

class DominoFaceView: UIView {
    enum Value: Int {
        case zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve
    }

    var value: Value? {
        didSet {
            setNeedsDisplay()
        }
    }
}
