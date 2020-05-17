//
//  DominoTests.swift
//  Tests
//
//  Created by Ceri on 10/05/2020.
//

import XCTest

@testable import MexicanTrain

class DominoTests: XCTestCase {
    func testAllDominoes() {
        let dominoes = UnplayedDomino.allDominoes()
        XCTAssertEqual(dominoes.count, 91)
        XCTAssertEqual(dominoes[0], UnplayedDomino(value1: .zero, value2: .zero))
        XCTAssertEqual(dominoes[1], UnplayedDomino(value1: .zero, value2: .one))
        XCTAssertEqual(dominoes[89], UnplayedDomino(value1: .eleven, value2: .twelve))
        XCTAssertEqual(dominoes[90], UnplayedDomino(value1: .twelve, value2: .twelve))
    }
}
