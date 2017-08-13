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
    static func createOneSidedPolyominos(withCellNum cellNum: Int) -> [Polyomino] {
        if cellNum == 0 {
            return [Polyomino.nomino]
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
            polyominoes = polyominoes.reduce([Polyomino]()) {
                current, polyomino in
                var nextResult = current
                let candidates = addCell(to: polyomino, in: current)
                for candidate in candidates {
                    if !nextResult.contains(candidate) {
                        nextResult.append(candidate)
                    }
                }
                return nextResult
            }
        }
        return polyominoes
    }
    
    /// Add one cell to a polyomino and get all unique polyomionoes.
    ///
    /// - Parameters:
    ///   - polyomino: polyomino to add cell to
    ///   - current: current list of polyominoes derived from the target polyomino
    /// - Returns: a list of polyominoes
    static private func addCell(to polyomino: Polyomino, in current: [Polyomino]) -> [Polyomino] {
//        print("number of  points: \(polyomino.growthPoints.count) on \(polyomino)")
        var uniquePolyominoes = [Polyomino]()
        for growthPoint in polyomino.growthPoints {
            let candidate = Polyomino(fromPoints: polyomino.points + [growthPoint])
            var preparedCandidate = candidate
            var qualified = true
            for _ in 0..<4 {
                preparedCandidate = preparedCandidate
                    .clockwiseRotated(around: candidate.points.first!)
                    .normalized()
                if uniquePolyominoes.contains(preparedCandidate) || current.contains(preparedCandidate) {
                    qualified = false
                    break
                }
            }
            if qualified {
//                print("Adding \(candidate.normalized()) to unique set: \(uniquePolyominoes)")
                uniquePolyominoes.append(candidate.normalized())
            }
        }
        return uniquePolyominoes
    }
    
}
