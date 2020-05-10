//
//  ShufflerTests.swift
//  Tests
//
//  Created by Home on 10/05/2020.
//

import XCTest

@testable import MexicanTrain

class ShufflerTests: XCTestCase {
    private var data: [Int]!
    private var shuffler: Shuffler!

    override func setUp() {
        super.setUp()

        data = [1, 2, 3, 4, 5, 6, 7, 8]
        shuffler = MockShuffler()
    }

    override func tearDown() {
        shuffler = nil
        data = nil

        super.tearDown()
    }

    func testRemoveRandomElement() {
        let removed = data.removeRandomElement(using: shuffler)
        XCTAssertEqual(removed, 8)
        XCTAssertEqual(data, [1, 2, 3, 4, 5, 6, 7])
    }

    func testRemoveRandomElement_noData() {
        var data = [Int]()
        let removed = data.removeRandomElement(using: shuffler)
        XCTAssertNil(removed)
    }

    func testRemoveRandomElements() {
        let removed = data.removeRandomElements(4, using: shuffler)
        XCTAssertEqual(removed, [8, 7, 6, 5])
        XCTAssertEqual(data, [1, 2, 3, 4])
    }

    func testRemoveRandomElements_noData() {
        var data = [Int]()
        let removed = data.removeRandomElements(4, using: shuffler)
        XCTAssertEqual(removed, [])
    }

    func testRemoveRandomElements_notEnough() {
        let removed = data.removeRandomElements(10, using: shuffler)
        XCTAssertEqual(removed, [8, 7, 6, 5, 4, 3, 2, 1])
        XCTAssertEqual(data, [])
    }
}
