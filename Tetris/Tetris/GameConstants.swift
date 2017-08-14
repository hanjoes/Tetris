import CoreGraphics

struct GameConstants {
    static let HorizontalCellNum: CGFloat = 10
    static let VerticalCellNum: CGFloat = 20
    
    static let SpawnAreaKey = "SpawnArea"
    static let TetrisArenaKey = "TetrisArena"
    
    /// Interval for a piece to drop by one cell in second.
    static let DefaultDropInterval = 0.5
    static let DefaultComplexity = 4
}
