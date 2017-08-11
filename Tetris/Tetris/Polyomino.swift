import UIKit

/// The `Polyomino` is represented by a list of `CGPoint`s which
/// are used to indicate the bottom-left corner of all the cells
/// in a real polyomino.
///
/// [Definition of Polyomino](https://en.wikipedia.org/wiki/Polyomino)
struct Polyomino {
    
    /// Points defines this polyomino.
    /// The points represents the bottom-left corner of
    /// the cells.
    var points: [CGPoint]
    
    /// Create a `Polyomino` by a list of points
    ///
    /// - Parameter points: the list of points defines a `Polyomino`
    init(fromPoints points: [CGPoint]) {
        self.points = points
    }
    
    func normalized() -> Polyomino {
        return self
    }
    
    func clockwiseRotated() -> Polyomino {
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
