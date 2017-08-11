import UIKit

/// Creates polyominoes.
struct PolyominoCreator {
    
    /// Creates all possible Polyominos for the given cell num.
    ///
    /// This method creates polyomino inductively, meaning we first create
    /// n-1 polyomino and generate n polyomino by adding one cell to the
    /// n-1 polyomino and de-duplicate them.
    ///
    /// - Parameter cellNum: number of cells in the generated polyomino
    /// - Returns: a polyomino
    func createPolyominos(withCellNum cellNum: Int) -> [Polyomino] {
        guard cellNum > 0 else {
            return [Polyomino]()
        }
        
        if cellNum == 1 {
            return [Polyomino(fromPoints: [CGPoint(x: 0, y: 0)])]
        }
        
        //
        // For `cellNum` >= 2 we use domino as our base case for
        // inductive construction of other higher-level polyominoes.
        //
        // Also, we consider our base case domino composed of two cells
        // using (0, 0) and (1, 0) as their bottom right corners:
        //       __   __
        //      |__| |__|
        //    (0,0) (1,0)
        //
        let points = [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)]
        let domino = Polyomino(fromPoints: points)
        
        var polyominoes = [domino]
        for _ in 2..<cellNum {
            polyominoes = polyominoes.flatMap { addCellTo(polyomino: $0) }
        }
        return polyominoes
    }
    
    
    /// Add one cell to a polyomino and get all unique polyomionoes.
    ///
    /// - Parameter polyomino: the initial polyomino
    /// - Returns: all possible de-duped polyominoes
    private func addCellTo(polyomino: Polyomino) -> [Polyomino] {
        var uniquePolyominoes = [Polyomino]()
        return [Polyomino(fromPoints: [CGPoint]())]
    }
    
}
