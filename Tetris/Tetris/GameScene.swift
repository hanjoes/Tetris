import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var blockTextureAtlas = [SKTextureAtlas]()
    
    let entityManager = EntityManager()
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    var hitSound: SKAction {
        return SKAction.playSoundFileNamed(GameConstants.HitSoundFileName, waitForCompletion: false)
    }
    
    func updateScore(withRowsCleared rowsCleared: Int) {
        guard rowsCleared > 0 else {
            return
        }
        score += rowsCleared
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
    
    /// There will be a preparing polyomino anytime when the game is in progress.
    var preparingPolyomino: PolyominoEntity?
    
    /// Similar to `preparingPolyomino` there will always be one dropping.
    weak var droppingPolyomino: PolyominoEntity?
    
    /// Creator that creates polyominoes in the game.
    var creator: PolyominoCreator!
    
}

// MARK: - Lifecycle methods
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        entityManager.update(deltaTime: deltaTime)
    }
    
    override func didMove(to view: SKView) {
        initializeArena()
        initializeButtons()
        initializeTextures()
        initializePolyominoCreator()
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
        entityManager.polyomino?.pourIntoArena()
        entityManager.remove(entity: droppingPolyomino!)
        droppingPolyomino = nil
        stagePolyomino()
        spawnPolyominoEntity()
        entityManager.arena.clearIfFull()
        run(hitSound)
    }
}

// MARK: - Spawning & Staging
private extension GameScene {
    func spawnPolyominoEntity() {
        guard preparingPolyomino == nil else {
            return
        }
        let arena = entityManager.arena
        let scale = arena.scale
        let prototype = creator.makeRandomPolyomino()
        let polyominoComponent = PolyominoComponent(withTexture: nil, withScale: scale, withPrototype: prototype)
        let rotationComponent = RotationComponent()
        let collisionCheckingComponent = CollisionCheckingComponent()
        let moveComponent = FixedMoveComponent()
        moveComponent.delegate = self
        
        let newPolyominoEntity = PolyominoEntity(withComponents: [polyominoComponent,
                                                                  moveComponent,
                                                                  collisionCheckingComponent,
                                                                  rotationComponent],
                                                 withEntityManager: entityManager)
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
        let arena = entityManager.arena
        let scale = arena.scale
        let arenaSprite = arena.arenaComponent.sprite
        polyominoComponent.reparent(toNewParent: arenaSprite)
        polyominoComponent.position = CGPoint.zero
        guard let fixedMoveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
            return
        }
        
        fixedMoveComponent.move(by: polyominoComponent.position.translation(to: CGPoint(x: -scale, y: arenaSprite.frame.height / 2)))
    }
}


// MARK: - Initializations
private extension GameScene {
    func initializeArena() {
        guard let arenaSprite = childNode(withName: GameConstants.TetrisArenaKey) as? SKSpriteNode else {
            return
        }
        let arenaComponent = ArenaComponent(withSpriteNode: arenaSprite)
        let arenaEntity = ArenaEntity(withComponents: [arenaComponent], withEntityManager: entityManager)
        entityManager.add(entity: arenaEntity)
    }
    
    func initializeButtons() {
        initializeLeftButton()
        initializeRightButton()
        initializeDownButton()
        initializeRotateButton()
    }
    
    func initializeScore() {
        score = 0
    }
    
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
