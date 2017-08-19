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
    
    /// A list of `CGPoint`s we can "grow" the polyomino by adding cells using them
    /// as bottom-left corner.
    var growthPoints: [CGPoint] {
        return points.reduce([CGPoint]()) {
            current, point in
            let neighbors = point.adjacentPoints(with: 1.0)
            var nextResult = current
            for neighbor in neighbors {
                if !nextResult.contains(neighbor) && !self.points.contains(neighbor) {
                    nextResult.append(neighbor)
                }
            }
            return nextResult
        }
    }
    
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
    /// - Parameter pivot: the pivot to rotate around
    /// - Returns: the clockwise rotated polyomino
    func clockwiseRotated(around pivot: CGPoint) -> Polyomino {
        return Polyomino(fromPoints: points
            .map { $0.translate(by: CGPoint(x: 1, y: 0)) }
            .map { $0.clockwiseRotated(around: pivot) })
    }
    
    /// Rotates a polyomino counter-clockwise by 90 degrees.
    ///
    /// - Parameter pivot: the pivot to rotate around
    /// - Returns: the counter-clockwise rotated polyomino
    func counterClockwiseRotated(around pivot: CGPoint) -> Polyomino {
        return Polyomino(fromPoints: points
            .map { $0.translate(by: CGPoint(x: 0, y: 1)) }
            .map { $0.counterClockwiseRotated(around: pivot) })
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
