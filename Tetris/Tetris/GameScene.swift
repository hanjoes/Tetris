import SpriteKit
import GameplayKit


// TODO: - Switch to GameplayKit
class GameScene: SKScene {
    
    var blockTextureAtlas = [SKTextureAtlas]()
    
    /// The arena where we actually play the game.
    var arena: SKNode {
        return childNode(withName: GameConstants.TetrisArenaKey)!
    }
    
    var score: Int = 0 {
        didSet {
            print("updating score")
            scoreLabel.text = "\(score)"
        }
    }
    
    /// The area where we spawn polyominoes.
    var spawnArea: SKNode {
        return childNode(withName: GameConstants.SpawnAreaKey)!
    }
    
    var scoreLabel: SKLabelNode {
        return childNode(withName: GameConstants.ScoreLabelKey) as! SKLabelNode
    }
    
    /// The buckets by row, containing stable nodes.
    var nodesBuckets = [[SKNode]]()
    
    var currentDropInterval = GameConstants.DefaultDropInterval
    
    /// Last time the polyomino in the arena dropped.
    var lastDropTime: Double = 0.0
    
    /// Last time the polyomino in the arena moved horizontally.
    var lastMoveTime: Double = 0.0
    
    /// There will be a preparing polyomino anytime when the game is in progress.
    var preparingPolyomino: SKPolyomino! {
        didSet {
            if preparingPolyomino == nil {
                spawnPreparingPolyomino()
            }
        }
    }
    
    /// Similar to `preparingPolyomino` there will always be one dropping.
    var droppingPolyomino: SKPolyomino!
    
    /// Creator that creates polyominoes in the game.
    var creator: PolyominoCreator!
    
    /// Scale of the cells used in the polyominoes in the arena.
    var scale: CGFloat {
        return arena.frame.width / GameConstants.HorizontalCellNum
    }
    
    override func didMove(to view: SKView) {
        initializeButtons()
        initializeTextures()
        initializePolyominoCreator()
        initializeBuckets()
        initializeScore()
    }
    
    override func update(_ currentTime: TimeInterval) {
        spawnPreparingPolyomino()
        updateDroppingPolyomino(currentTime)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}


// MARK: - Buttons
private extension GameScene {
    
    var leftButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.LeftButtonKey)! as! ButtonSpriteNode
    }
    
    var rightButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.RightButtonKey)! as! ButtonSpriteNode
    }
    
    var downButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.DownButtonKey)! as! ButtonSpriteNode
    }
    
    var rotateButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.RotateButtonKey)! as! ButtonSpriteNode
    }
    
    func initializeButtons() {
        initializeLeftButton()
        initializeRightButton()
        initializeDownButton()
        initializeRotateButton()
    }
    
    func initializeLeftButton() {
        leftButton.isUserInteractionEnabled = true
        leftButton.touchDownHandler = {
            [unowned self] in
            self.droppingPolyomino.direction = .left
            self.moveHorizontally()
            self.lastMoveTime = 0.0
        }
        
        leftButton.touchUpHandler = {
            [unowned self] in
            self.droppingPolyomino.direction = self.rightButton.buttonDown ? .right : .none
        }
    }
    
    func initializeRightButton() {
        rightButton.isUserInteractionEnabled = true
        rightButton.touchDownHandler = {
            [unowned self] in
            self.droppingPolyomino.direction = .right
            self.moveHorizontally()
            self.lastMoveTime = 0.0
        }
        rightButton.touchUpHandler = {
            [unowned self] in
            self.droppingPolyomino.direction = self.leftButton.buttonDown ? .left : .none
        }
    }
    
    func initializeDownButton() {
        downButton.isUserInteractionEnabled = true
        downButton.touchDownHandler = {
            [unowned self] in
            self.currentDropInterval = GameConstants.HurriedUpDropInterval
        }
        downButton.touchUpHandler = {
            [unowned self] in
            self.currentDropInterval = GameConstants.DefaultDropInterval
        }
    }
    
    func initializeRotateButton() {
        rotateButton.isUserInteractionEnabled = true
        rotateButton.touchDownHandler = {
            [unowned self] in
            if self.canTurnClockwise(by: self.rotationTranslations) {
                self.droppingPolyomino.turn(by: self.rotationTranslations)
            }
        }
    }
}

// MARK: - Helpers
private extension GameScene {

    var hitSound: SKAction {
        return SKAction.playSoundFileNamed(GameConstants.HitSoundFileName, waitForCompletion: false)
    }

    var canDrop: Bool {
        return droppingPolyomino.spriteNodes.filter {
            var noHit = true
            let nextPosition = $0.frame.origin.translate(by: CGPoint(x: 0, y: -scale))
            if nextPosition.y < -(arena.frame.height / 2) {
                noHit = false
            }
            else {
                if checkOverlap(forPosition: nextPosition) {
                    noHit = false
                }
            }
            return noHit
        }.count == droppingPolyomino.spriteNodes.count
    }
    
    var canMoveLeft: Bool {
        return droppingPolyomino.spriteNodes.filter {
            var noHit = true
            let nextPosition = $0.frame.origin.translate(by: CGPoint(x: -scale, y: 0))
            if nextPosition.x < -(arena.frame.width / 2) {
                noHit = false
            }
            else {
                if checkOverlap(forPosition: nextPosition) {
                    noHit = false
                }
            }
            return noHit
        }.count == droppingPolyomino.spriteNodes.count
    }
    
    var canMoveRight: Bool {
        return droppingPolyomino.spriteNodes.filter {
            var noHit = true
            let nextPosition = $0.frame.origin.translate(by: CGPoint(x: scale, y: 0))
            if nextPosition.x > (arena.frame.width / 2 - scale) {
                noHit = false
            }
            else {
                if checkOverlap(forPosition: nextPosition) {
                    noHit = false
                }
            }
            return noHit
        }.count == droppingPolyomino.spriteNodes.count
    }
    
    var rotationTranslations: [CGPoint] {
        let anchorPoint = droppingPolyomino.anchorPoint
//        print("anchor: \(anchorPoint) points: \(droppingPolyomino.spriteNodes.map { $0.frame.origin})")
        let centeringTranslation = anchorPoint.translation(to: CGPoint.zero)
        return droppingPolyomino.spriteNodes.map {
            let x = $0.frame.minX
            let y = $0.frame.minY
            let bottomLeftCorner = CGPoint(x: x, y: y)
            let translated = bottomLeftCorner.translate(by: centeringTranslation)
            let rotated = CGPoint(x: translated.y, y: -translated.x)
            let rotationTranslation = translated.translation(to: rotated)
            return rotationTranslation
        }
    }
    
    func canTurnClockwise(by translations: [CGPoint]) -> Bool {
        guard translations.count == droppingPolyomino.spriteNodes.count else {
            return false
        }
        
        for index in 0..<translations.count {
            let node = droppingPolyomino.spriteNodes[index]
            let translation = translations[index]
            let nextPosition = node.frame.origin.translate(by: translation)
            if nextPosition.x > (arena.frame.width / 2 - scale) ||
                nextPosition.x < -(arena.frame.width / 2) ||
                nextPosition.y < -(arena.frame.height / 2 - scale) {
                return false
            }
            else {
                if checkOverlap(forPosition: nextPosition) {
                    return false
                }
            }
        }
        return true
    }
    
    func initializeScore() {
        score = 0
    }
    
    func initializeBuckets() {
        let numRow = Int(arena.frame.height / scale)
        nodesBuckets = [[SKNode]](repeating: [SKNode](), count: numRow)
    }
    
    /// Initializes the creator for `Polyomino`.
    func initializePolyominoCreator() {
        creator = PolyominoCreator(forCellNum: GameConstants.DefaultComplexity, withAtlas: blockTextureAtlas.first!)
    }
    
    func initializeTextures() {
        blockTextureAtlas = [
            SKTextureAtlas(named: GameConstants.BlueBlockAtlasName),
            SKTextureAtlas(named: GameConstants.GreenBlockAtlasName),
            SKTextureAtlas(named: GameConstants.YellowBlockAtlasName),
            SKTextureAtlas(named: GameConstants.PinkBlockAtlasName)
        ]
    }
    
    /// Spawn a preparing `Polyomino` at the spawning area.
    func spawnPreparingPolyomino() {
        guard preparingPolyomino == nil else {
            return
        }
        
        preparingPolyomino = creator.makeRandomPolyomino(withScale: scale)
        let spawnArea = childNode(withName: GameConstants.SpawnAreaKey)!
        preparingPolyomino.center(to: spawnArea)
    }
    
    func moveHorizontally() {
        switch droppingPolyomino.direction {
        case .left:
            if canMoveLeft {
                droppingPolyomino.move(by: CGPoint(x: -scale, y: 0))
            }
        case .right:
            if canMoveRight {
                droppingPolyomino.move(by: CGPoint(x: scale, y: 0))
            }
        default:
            break
        }
    }
    
    /// Update the dropping polyomino, this method will ensure we have a
    /// polyomino in the arena and preparing polyomino will be updated after
    /// we used the polyomino in spawning area.
    /// - Parameter currentTime: time when update is called
    func updateDroppingPolyomino(_ currentTime: TimeInterval) {
        if droppingPolyomino == nil {
            stagePolyomino()
        }
        
        if currentTime - lastMoveTime >= GameConstants.HorizontalMovingInterval {
            // don't move when we haven't moved, removing this line
            // will cause double movement issue.
            if lastMoveTime != 0.0 {
                moveHorizontally()
            }
            lastMoveTime = currentTime
        }
        
        if currentTime - lastDropTime >= currentDropInterval {
            lastDropTime = currentTime
            if canDrop {
                droppingPolyomino.move(by: CGPoint(x: 0, y: -scale))
            }
            else {
                pour(nodes: droppingPolyomino.spriteNodes)
                clearIfRowFull()
                stagePolyomino()
                run(hitSound)
            }
        }
    }
    
    func pour(nodes: [SKNode]) {
        for node in nodes {
            let rowIndex = Int((node.frame.minY + arena.frame.height / 2) / scale)
            nodesBuckets[rowIndex].append(node)
        }
    }
    
    func clearIfRowFull() {
        let fullRowNum = Int(arena.frame.width / scale)
        var rowsCleared = 0
        for rowIndex in 0..<nodesBuckets.count {
            let row = nodesBuckets[rowIndex]
            if row.count == fullRowNum {
                _ = row.map { $0.removeFromParent() }
                nodesBuckets[rowIndex].removeAll()
                rowsCleared += 1
            }
        }
        compressRows()
        updateScore(withRowsCleared: rowsCleared)
    }
    
    func checkOverlap(forPosition position: CGPoint) -> Bool {
        for row in nodesBuckets {
            for node in row {
                if position == node.frame.origin {
                    return true
                }
            }
        }
        return false
    }
    
    func compressRows() {
        let numRows = Int(arena.frame.height / scale)
        for rowIndex in 0..<numRows {
            var currentRow = rowIndex
            if nodesBuckets[currentRow].isEmpty {
                while nodesBuckets[currentRow].isEmpty {
                    currentRow += 1
                    if currentRow == numRows {
                        return
                    }
                }
                descend(rowIndex: currentRow, by: currentRow - rowIndex)
                nodesBuckets[rowIndex] = nodesBuckets[currentRow]
                nodesBuckets[currentRow].removeAll()
            }
        }
    }
    
    func updateScore(withRowsCleared rowsCleared: Int) {
        guard rowsCleared > 0 else {
            return
        }
        score += rowsCleared
    }
    
    func descend(rowIndex index: Int, by level: Int) {
        guard index >= 0 && index < nodesBuckets.count else {
            return
        }
        let row = nodesBuckets[index]
        for node in row {
            node.position = node.position.translate(by: CGPoint(x: 0, y: -scale * CGFloat(level)))
        }
    }
    
    func stagePolyomino() {
        droppingPolyomino = preparingPolyomino
        droppingPolyomino.move(to: arena)
        droppingPolyomino.position = CGPoint(x: -scale, y: arena.frame.height / 2)
        preparingPolyomino = nil
    }
}