import XCTest
@testable import Tetris

class PolyominoTests: XCTestCase {
    
    // MARK: sorted
    
    func testHorizontalSorted() {
        let polyomino = Polyomino(fromPoints: [CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 0)])
        XCTAssertEqual([CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)], polyomino.points)
    }
    
    func testVerticalSorted() {
        let polyomino = Polyomino(fromPoints: [CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1)])
        XCTAssertEqual(polyomino.points, [CGPoint(x: 1, y: 1), CGPoint(x: 1, y: 0)])
    }
    
    // MARK: normalized
    
    static let normalizedDomino = Polyomino(fromPoints: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)])
    
    func testNormalizingEmpty() {
        let polyomino = Polyomino.nomino
        let normalized = polyomino.normalized()
        XCTAssertEqual(polyomino, normalized)
    }
    
    func testNormalizingNormalized() {
        let polyomino = PolyominoTests.normalizedDomino
        let normalized = polyomino.normalized()
        XCTAssertEqual(polyomino, normalized)
    }
    
    func testNormalizingRandomDomino() {
        let polyomino = Polyomino(fromPoints: [
            CGPoint(x: 32, y: 43),
            CGPoint(x: 33, y: 43)])
        let normalized = polyomino.normalized()
        XCTAssertEqual(PolyominoTests.normalizedDomino, normalized)
    }
    
    // MARK: clockwise rotated
    
    static let normalizedTetrimino = Polyomino(fromPoints: [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 0),
        CGPoint(x: 1, y: 1),
        CGPoint(x: 2, y: 1)])
    
    func testClockwiseRotatedAroundAnotherPoint() {
        let polyomino = PolyominoTests.normalizedTetrimino
        let clockwiseRotated = polyomino.clockwiseRotated(around: CGPoint(x: 1, y: 2))
        XCTAssertEqual(Polyomino(fromPoints: [
            CGPoint(x: -1, y: 2),
            CGPoint(x: 0, y: 1),
            CGPoint(x: -1, y: 1),
            CGPoint(x: 0, y: 0)]), clockwiseRotated)
    }
    
    func testCounterClockwiseRotatedAroundAnotherPoint() {
        let polyomino = PolyominoTests.normalizedTetrimino
        let counterClockwiseRotated = polyomino.counterClockwiseRotated(around: CGPoint(x: 1, y: 2))
        XCTAssertEqual(Polyomino(fromPoints: [
            CGPoint(x: 1, y: 3),
            CGPoint(x: 1, y: 2),
            CGPoint(x: 2, y: 2),
            CGPoint(x: 2, y: 1)]), counterClockwiseRotated)
    }
}
