import Foundation

/// Creates polyominoes.
protocol PolyominoCreator {
    
    /// Create one polyomino with given cell num.
    ///
    /// - Parameter cellNum: number of cells in the generated polyomino
    /// - Returns: a polyomino
    func createPolyomino(withCellNum cellNum: Int) -> Polyomino
}
