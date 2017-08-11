//
//  TetrisTests.swift
//  TetrisTests
//
//  Created by Hanzhou Shi on 8/7/17.
//  Copyright © 2017 Hanzhou Shi. All rights reserved.
//

import XCTest
@testable import Tetris

class TetrisTests: XCTestCase {
    
    func testHorizontalSorted() {
        let polyomino = Polyomino(fromPoints: [CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 0)])
        XCTAssertEqual(polyomino.points, [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)])
    }
    
    func testVerticalSorted() {
        let polyomino = Polyomino(fromPoints: [CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1)])
        XCTAssertEqual(polyomino.points, [CGPoint(x: 1, y: 1), CGPoint(x: 1, y: 0)])
    }
    
}
