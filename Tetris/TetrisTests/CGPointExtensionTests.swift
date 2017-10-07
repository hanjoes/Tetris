import XCTest
import Nimble
@testable import Tetris

class CGPointExtensionTests: XCTestCase {
    
    // MARK: Translation
    
    func testTranslationFromSelf() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.translation(from: p)
        expect(actual) == CGPoint.zero
    }
    
    func testTranslationFromDifferentPoint() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.translation(from: CGPoint.zero)
        expect(actual) == p
    }
    
    func testTranslationToSelf() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.translation(to: p)
        expect(actual) == CGPoint.zero
    }

    func testTranslationToDifferentPoint() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.translation(to: CGPoint.zero)
        expect(actual) == CGPoint(x: -1, y: -1)
    }
    
    func testTranslationByIdentity() {
        let p = CGPoint(x: 5, y: 6)
        let actual = p.translate(by: CGPoint.zero)
        expect(actual) == p
    }
    
    func testTranslationByPoint() {
        let p = CGPoint(x: 3, y: 5)
        let actual = p.translate(by: CGPoint(x: 2, y: 4))
        expect(actual) == CGPoint(x: 5, y: 9)
    }
    
    // MARK: Rotation
    
    func testClockWiseRotateBySelf() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.clockwiseRotated(around: p)
        expect(actual) == p
    }
    
    func testClockWiseRotateByAnotherPoint() {
        let p = CGPoint(x: 1, y: 2)
        let actual = p.clockwiseRotated(around: CGPoint(x: 3, y: 4))
        expect(actual) == CGPoint(x: 1, y: 6)
    }
    
    func testCounterClockWiseRotateBySelf() {
        let p = CGPoint(x: 1, y: 1)
        let actual = p.counterClockwiseRotated(around: p)
        expect(actual) == p
    }
    
    func testCounterClockWiseRotateByAnotherPoint() {
        let p = CGPoint(x: 1, y: 2)
        let actual = p.counterClockwiseRotated(around: CGPoint(x: 3, y: 4))
        expect(actual) == CGPoint(x: 5, y: 2)
    }
    
    // MARK: adjacent points
    
    func testGeneratingNeighbors() {
        let p = CGPoint(x: 1, y: 2)
        let actual = p.adjacentPoints(with: 1)
        expect(actual).to(contain(CGPoint(x: 2, y: 2)))
        expect(actual).to(contain(CGPoint(x: 0, y: 2)))
        expect(actual).to(contain(CGPoint(x: 1, y: 1)))
        expect(actual).to(contain(CGPoint(x: 1, y: 3)))
    }
    
}
