import CoreGraphics

struct GameConstants {
    static let HorizontalCellNum: CGFloat = 10
    static let VerticalCellNum: CGFloat = 20
    
    static let HorizontalMovingInterval = 0.2
    
    static let SpawnAreaKey = "SpawnArea"
    static let TetrisArenaKey = "TetrisArena"
    static let LeftButtonKey = "LeftButton"
    static let RightButtonKey = "RightButton"
    static let DownButtonKey = "DownButton"
    static let RotateButtonKey = "RotateButton"
    
    /// Interval for a piece to drop by one cell in second.
    static let DefaultDropInterval = 0.3
    static let DefaultComplexity = 4
}
