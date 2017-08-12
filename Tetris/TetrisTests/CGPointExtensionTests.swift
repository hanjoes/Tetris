import XCTest
@testable import Tetris

class CGPointExtensionTests: XCTestCase {
    
    // MARK: Translation
    
    func testTranslationFromSelf() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.translation(from: p)
        XCTAssertEqual(CGPoint.zero, actual)
    }
    
    func testTranslationFromDifferentPoint() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.translation(from: CGPoint.zero)
        XCTAssertEqual(p, actual)
    }
    
    func testTranslationToSelf() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.translation(to: p)
        XCTAssertEqual(CGPoint.zero, actual)
    }

    func testTranslationToDifferentPoint() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.translation(to: CGPoint.zero)
        XCTAssertEqual(CGPoint(x: -1, y: -1), actual)
    }
    
    func testTranslationByIdentity() {
        let p = CGPoint(x: 5, y: 6)
        let actual = p.translate(by: CGPoint.zero)
        XCTAssertEqual(p, actual)
    }
    
    func testTranslationByPoint() {
        let p = CGPoint(x: 3, y: 5)
        let actual = p.translate(by: CGPoint(x: 2, y: 4))
        XCTAssertEqual(CGPoint(x: 5, y: 9), actual)
    }
    
    // MARK: Rotation
    
    func testClockWiseRotateBySelf() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.clockwiseRotated(around: p)
        XCTAssertEqual(p, actual)
    }
    
    func testClockWiseRotateByAnotherPoint() {
        let p = CGPoint(x: 1, y: 2)
        let actual = p.clockwiseRotated(around: CGPoint(x: 3, y: 4))
        XCTAssertEqual(CGPoint(x: 1, y: 6), actual)
    }
    
    func testCounterClockWiseRotateBySelf() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.counterClockwiseRotated(around: p)
        XCTAssertEqual(p, actual)
    }
    
    func testCounterClockWiseRotateByAnotherPoint() {
        let p = CGPoint(x: 1, y: 2)
        let actual = p.counterClockwiseRotated(around: CGPoint(x: 3, y: 4))
        XCTAssertEqual(CGPoint(x: 5, y: 2), actual)
    }
    
}
