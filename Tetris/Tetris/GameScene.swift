import SpriteKit
import GameplayKit


// TODO: - Switch to GameplayKit
class GameScene: SKScene {
    
    var blockTextureAtlas = [SKTextureAtlas]()
    
    /// The arena where we actually play the game.
    var arena: SKNode {
        return childNode(withName: GameConstants.TetrisArenaKey)!
    }
    
    let entityManager = EntityManager()
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    // Update time
    var lastUpdateTime: TimeInterval = 0
    
    /// The area where we spawn polyominoes.
    var spawnArea: SKNode {
        return childNode(withName: GameConstants.SpawnAreaKey)!
    }
    
    var scoreLabel: SKLabelNode {
        return childNode(withName: GameConstants.ScoreLabelKey) as! SKLabelNode
    }
    
    /// The buckets by row, containing stable nodes.
    var nodesBuckets = [[SKNode]]()
    
    /// There will be a preparing polyomino anytime when the game is in progress.
    var preparingPolyomino: PolyominoEntity?
    
    /// Similar to `preparingPolyomino` there will always be one dropping.
    weak var droppingPolyomino: PolyominoEntity?
    
    /// Creator that creates polyominoes in the game.
    var creator: PolyominoCreator!
    
    /// Scale of the cells used in the polyominoes in the arena.
    var scale: CGFloat {
        return arena.frame.width / GameConstants.HorizontalCellNum
    }
    
}

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        entityManager.update(deltaTime: deltaTime)
    }
    
    override func didMove(to view: SKView) {
        initializeButtons()
        initializeTextures()
        initializePolyominoCreator()
        initializeBuckets()
        initializeScore()
        
        spawnPolyominoEntity()
        stagePolyomino()
        spawnPolyominoEntity()
    }
}

// MARK: - FixedMoveComponentDelegate
extension GameScene: FixedMoveComponentDelegate {
    func didStablize() {
        // FIXME: transfer sprite nodes into arena.
        pour()
        entityManager.remove(entity: droppingPolyomino!)
        droppingPolyomino = nil
        stagePolyomino()
        spawnPolyominoEntity()
        clearIfRowFull()
        run(hitSound)
    }
    
    func pour() {
        guard let polyominoComponent = droppingPolyomino?.component(ofType: PolyominoComponent.self) else {
            return
        }
        for spriteComponent in polyominoComponent.spriteComponents {
            let rowIndex = Int((spriteComponent.sprite.frame.minY + arena.frame.height / 2) / scale)
            nodesBuckets[rowIndex].append(spriteComponent.sprite)
        }
    }
}

// MARK: - Spawning & Staging
private extension GameScene {
    func spawnPolyominoEntity() {
        guard preparingPolyomino == nil else {
            return
        }
        
        let prototype = creator.makeRandomPolyomino()
        let polyominoComponent = PolyominoComponent(withTexture: nil, withScale: scale, withPrototype: prototype)
        let rotationComponent = RotationComponent()
        let moveComponent = FixedMoveComponent()
        moveComponent.delegate = self

        // FIXME: Really bad to depend on GameScene, refactor it into arena entity prob?
        let collisionCheckingComponent = CollisionCheckingComponent(inFrame: arena.frame, inGameScene: self)
        
        let newPolyominoEntity = PolyominoEntity(withComponents: [polyominoComponent,
                                                                  moveComponent,
                                                                  collisionCheckingComponent,
                                                                  rotationComponent])
        preparingPolyomino = newPolyominoEntity
        
        polyominoComponent.reparent(toNewParent: spawnArea)
        let midPointX = polyominoComponent.prototype.midPoint.x
        let midPointY = polyominoComponent.prototype.midPoint.y
        let midPoint = CGPoint(x: midPointX * scale, y: midPointY * scale)
        polyominoComponent.position = polyominoComponent.position.translate(by: midPoint.translation(to: CGPoint.zero))
    }
    
    func stagePolyomino() {
        guard droppingPolyomino == nil, preparingPolyomino != nil else {
            return
        }
        
        droppingPolyomino = preparingPolyomino
        entityManager.entities.insert(droppingPolyomino!)
        preparingPolyomino = nil
        
        guard let polyominoComponent = droppingPolyomino?.component(ofType: PolyominoComponent.self) else {
            return
        }
        
        polyominoComponent.reparent(toNewParent: arena)
        polyominoComponent.position = CGPoint.zero
        guard let fixedMoveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
            return
        }
        
        fixedMoveComponent.move(by: polyominoComponent.position.translation(to: CGPoint(x: -scale, y: arena.frame.height / 2)))
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
            
            guard let moveComponent = self.droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.direction = .left
            moveComponent.moveHorizontally()
            moveComponent.waitForMoveTime = 0.0
        }
        
        leftButton.touchUpHandler = {
            [unowned self] in
            
            guard let moveComponent = self.droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.direction = self.rightButton.buttonDown ? .right : .none
        }
    }
    
    func initializeRightButton() {
        rightButton.isUserInteractionEnabled = true
        
        rightButton.touchDownHandler = {
            [unowned self] in
            
            guard let moveComponent = self.droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.direction = .right
            moveComponent.moveHorizontally()
            moveComponent.waitForMoveTime = 0.0
        }
        rightButton.touchUpHandler = {
            [unowned self] in
            
            guard let moveComponent = self.droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.direction = self.leftButton.buttonDown ? .left : .none
        }
    }
    
    func initializeDownButton() {
        downButton.isUserInteractionEnabled = true

        
        downButton.touchDownHandler = {
            [unowned self] in
            guard let moveComponent = self.droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.currentDropInterval = GameConstants.HurriedUpDropInterval
        }
        downButton.touchUpHandler = {
            [unowned self] in
            guard let moveComponent = self.droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.currentDropInterval = GameConstants.DefaultDropInterval
        }
    }
    
    func initializeRotateButton() {
        rotateButton.isUserInteractionEnabled = true
        rotateButton.touchDownHandler = {
            [unowned self] in
            guard let rotationComponent = self.droppingPolyomino?.component(ofType: RotationComponent.self) else {
                return
            }
            
            guard let collider = self.droppingPolyomino?.component(ofType: CollisionCheckingComponent.self) else {
                return
            }
            
            if collider.canTurnClockwise() {
                rotationComponent.turnClockwise()
            }
        }
    }
}

// MARK: - Helpers
private extension GameScene {

    var hitSound: SKAction {
        return SKAction.playSoundFileNamed(GameConstants.HitSoundFileName, waitForCompletion: false)
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
        creator = PolyominoCreator(forCellNum: GameConstants.DefaultComplexity)
    }
    
    func initializeTextures() {
        blockTextureAtlas = [
            SKTextureAtlas(named: GameConstants.BlueBlockAtlasName),
            SKTextureAtlas(named: GameConstants.GreenBlockAtlasName),
            SKTextureAtlas(named: GameConstants.YellowBlockAtlasName),
            SKTextureAtlas(named: GameConstants.PinkBlockAtlasName)
        ]
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
   
}
