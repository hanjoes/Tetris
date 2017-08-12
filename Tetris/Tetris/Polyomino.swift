import UIKit

/// The `Polyomino` is represented by a list of `CGPoint`s which
/// are used to indicate the bottom-left corner of all the cells
/// in a real polyomino.
///
/// - Note: Assuming the scale of each cell is 1 here.
///
/// [Definition of Polyomino](https://en.wikipedia.org/wiki/Polyomino)
struct Polyomino {
    
    /// Constant for a `Polyomino` that contains no cell.
    static let nomino = Polyomino(fromPoints: [CGPoint]())
    
    /// Points defines this polyomino.
    /// The points represents the bottom-left corner of
    /// the cells.
    /// - Note: The points are always sorted. see `sorter` for detail.
    let points: [CGPoint]
    
    /// Sorts two points. A point to the left of another point appears
    /// before. A point above another point appears before.
    ///
    ///
    /// - Note: Direction in this function follows convention used in
    /// _SpriteKit_ so, positive direction for y axis grows from
    /// bottom of the screen to up of the screen.
    /// - Parameters:
    ///   - p1: one `CGPoint`
    ///   - p2: another `CGPoint`
    /// - Returns: boolean indicates whether `p1` goes before `p2`
    static func sorter(p1: CGPoint, p2: CGPoint) -> Bool {
        if p1.x < p2.x {
            return true
        }
        
        if p1.x == p2.x {
            return p1.y > p2.y
        }

        return false
    }
    
    /// Create a `Polyomino` by a list of points
    ///
    /// - Parameter points: the list of points defines a `Polyomino`
    init(fromPoints points: [CGPoint]) {
        self.points = points.sorted(by: Polyomino.sorter)
    }
    
    /// Normalize is to translate the polyomino so that the first
    /// point sits at the origin.
    ///
    /// - Returns: a new `Polyomino` normalized
    func normalized() -> Polyomino {
        guard !points.isEmpty else {
            return Polyomino.nomino
        }
        
        let origin = points.first!
        let translation = origin.translation(to: CGPoint.zero)
        let normalizedPoints = points.map { $0.translate(by: translation) }
        return Polyomino(fromPoints: normalizedPoints)
    }
    
    /// Rotates a polyomino clockwise by 90 degrees.
    ///
    /// - Returns: The clockwise-rotated polyomino.
    func clockwiseRotated() -> Polyomino {
        // 1. translate to make pivot origin
        // 2. shift all points to right by 1
        // 3. "rotate" the vector
        // 4. translate back
        return self
    }
}


// MARK: - Hashable
extension Polyomino: Hashable {
    var hashValue: Int {
        return points.map { "\($0)" }.joined(separator: "::").hashValue
    }
    
    static func ==(lhs: Polyomino, rhs: Polyomino) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
