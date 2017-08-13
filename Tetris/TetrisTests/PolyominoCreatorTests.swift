import XCTest
@testable import Tetris

class PolyominoCreatorTests: XCTestCase {
    
    // MARK: Creation
    
    func testCreateNomino() {
        let actual = PolyominoCreator.createOneSidedPolyominos(withCellNum: 0)
        XCTAssertEqual([Polyomino.nomino], actual)
    }
    
    func testCreateMonomino() {
        let actual = PolyominoCreator.createOneSidedPolyominos(withCellNum: 1)
        XCTAssertEqual([Polyomino(fromPoints: [CGPoint(x: 0, y: 0)])], actual)
    }
    
    func testCreateDomino() {
        let actual = PolyominoCreator.createOneSidedPolyominos(withCellNum: 2)
        XCTAssertEqual([Polyomino(fromPoints: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)])], actual)
    }
    
    func testCreateTromino() {
        let actual = PolyominoCreator.createOneSidedPolyominos(withCellNum: 3)
        XCTAssertEqual(2, actual.count)
    }
    
    func testCreateTetrimino() {
        let actual = PolyominoCreator.createOneSidedPolyominos(withCellNum: 4)
        XCTAssertEqual(7, actual.count)
    }
    
    func testCreatePentomino() {
        let actual = PolyominoCreator.createOneSidedPolyominos(withCellNum: 5)
        XCTAssertEqual(18, actual.count)
    }
    
    func testCreateHexomino() {
        let actual = PolyominoCreator.createOneSidedPolyominos(withCellNum: 6)
        XCTAssertEqual(60, actual.count)
    }
    
//    // MARK: SLOW!
//    func testCreateHeptomino() {
//        let actual = PolyominoCreator.createOneSidedPolyominos(withCellNum: 7)
//        XCTAssertEqual(196, actual.count)
//    }
}
