import CoreGraphics

// MARK: - Polyomino
struct Tetris: Polyomino {
    
    static var allPossible: [Polyomino] {
        return [
            Tetris(withPoints: [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 0),CGPoint(x: 1, y: -1),CGPoint(x: 2, y: -1)], withAnchor: CGPoint(x: 1, y: -1)),
            Tetris(withPoints: [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 1),CGPoint(x: 1, y: 0),CGPoint(x: 2, y: 0)], withAnchor: CGPoint(x: 1, y: 0)),
            Tetris(withPoints: [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 1),CGPoint(x: 1, y: 0),CGPoint(x: 2, y: 1)], withAnchor: CGPoint(x: 1, y: 0)),
            Tetris(withPoints: [CGPoint(x: 0, y: 0),CGPoint(x: 0, y: -1),CGPoint(x: 0, y: -2),CGPoint(x: 1, y: -2)], withAnchor: CGPoint(x: 0, y: -1)),
            Tetris(withPoints: [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 2),CGPoint(x: 1, y: 1),CGPoint(x: 1, y: 0)], withAnchor: CGPoint(x: 1, y: 1)),
            Tetris(withPoints: [CGPoint(x: 0, y: 0),CGPoint(x: 0, y: -1),CGPoint(x: 1, y: 0),CGPoint(x: 1, y: -1)], withAnchor: CGPoint(x: 0.5, y: -0.5)),
            Tetris(withPoints: [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 0),CGPoint(x: 2, y: 0),CGPoint(x: 3, y: 0)], withAnchor: CGPoint(x: 2, y: 0))
        ]
    }
    
    var points: [CGPoint]
    
    var anchorPoint: CGPoint
    
    var centerPoint: CGPoint {
        return anchorPoint.translate(by: CGPoint(x: 0.5, y: 0.5))
    }
    
    var cellNum: Int {
        return 4
    }

    
}

// MARK: - Initialization
extension Tetris {
    
    /// Initializer takes a list of points
    ///
    /// - Parameter points: points that represents this polyomino (bottom-left corner)
    /// - Parameter point: anchor point
    init(withPoints points: [CGPoint], withAnchor point: CGPoint) {
        self.points = points
        self.anchorPoint = point
    }
}
