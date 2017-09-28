import CoreGraphics

struct GameConstants {
    static let HorizontalCellNum: CGFloat = 10
    static let VerticalCellNum: CGFloat = 20
    
    static let DefaultDropInterval = 0.8
    static let MinimumDropInterval = 0.1
    static let HorizontalMovingInterval = 0.2
    static let HurriedUpDropInterval = 0.05
    
    static let SpawnAreaKey = "SpawnArea"
    static let TetrisArenaKey = "TetrisArena"
    static let LeftButtonKey = "LeftButton"
    static let RightButtonKey = "RightButton"
    static let GameStartButtonKey = "GameStartButton"
    static let RestartButton = "RestartButton"
    static let DownButtonKey = "DownButton"
    static let RotateButtonKey = "RotateButton"
    static let ScoreLabelKey = "ScoreLabel"
    static let GameScene = "GameScene"
    static let GameOverScene = "GameOverScene"
    static let GameStartScene = "GameStartScene"
    static let EndgameScoreLabelKey = "EndgameScoreLabel"
    
    /// Interval for a piece to drop by one cell in second.
    static let DefaultComplexity = 4
    
    static let HitSoundFileName = "hollow_thud.mp3"
    static let GameStartSceneMusic = "background_music"
    static let GameSceneMusic = "game_music"
    
    static let BlueBlockAtlasName = "BlueBlocks"
    static let GreenBlockAtlasName = "GreenBlocks"
    static let YellowBlockAtlasName = "YellowBlocks"
    static let PinkBlockAtlasName = "PinkBlocks"
    
    static let ArenaMaskImageName = "arena_mask"
    
    /// Rules
    static let CurrentScoreKey = "CurrentScore"
    static let ProceedToNextLevelFact = "ProceedToNextLevel"
    static let NumScoreBeforeProceeding = 20
}
