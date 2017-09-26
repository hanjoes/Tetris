import CoreGraphics

/// General representation of a polyomino. Conformant
/// types could be nomino, tetris, etc.
protocol Polyomino {
    
    /// static property that returns all possible polyominoes
    /// for a give `cellNum`.
    static var allPossible: [Polyomino] { get }
    
    /// A list of points representing the polyomino.
    /// Each point should be the bottom-left corner of
    /// the represented cell.
    var points: [CGPoint] { get }
    
    /// Number of cells this `Polyomino` contains.
    var cellNum: Int { get }
    
    /// Anchor point mainly used for rotation.
    var anchorPoint: CGPoint { get }
    
    /// Center point for display.
    var centerPoint: CGPoint { get }
}
