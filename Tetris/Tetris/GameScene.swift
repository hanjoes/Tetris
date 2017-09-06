import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let entityManager = EntityManager()
    
    var hitSound = SKAction.playSoundFileNamed(GameConstants.HitSoundFileName, waitForCompletion: false)
    
    var lastUpdateTime: TimeInterval = 0
}

// MARK: - Lifecycle methods
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        entityManager.update(deltaTime: deltaTime)
    }
    
    override func didMove(to view: SKView) {
        initializeSpawnArea()
        initializeArena()
        initializeButtons()
        initializeScore()
        
        entityManager.spawnArea.spawnPolyominoEntity(withDelegate: self)
        entityManager.spawnArea.stagePolyomino()
        entityManager.spawnArea.spawnPolyominoEntity(withDelegate: self)
    }
}


// MARK: - FixedMoveComponentDelegate
extension GameScene: FixedMoveComponentDelegate {
    func didStablize() {
        entityManager.polyomino?.pourIntoArena()
        entityManager.remove(entity: entityManager.arena.droppingPolyomino!)
        entityManager.spawnArea.stagePolyomino()
        entityManager.spawnArea.spawnPolyominoEntity(withDelegate: self)
        entityManager.arena.clearIfFull()
        run(hitSound)
    }
}

// MARK: - Initializations
private extension GameScene {
    func initializeSpawnArea() {
        guard let spawnAreaSprite = childNode(withName: GameConstants.SpawnAreaKey) as? SKSpriteNode else {
            return
        }
        
        let spawnAreaComponent = SpawnAreaComponent(withSpriteNode: spawnAreaSprite)
        let spawnAreaEntity = SpawnAreaEntity(withComponents: [spawnAreaComponent], withEntityManager: entityManager)
        entityManager.add(entity: spawnAreaEntity)
    }
    
    func initializeArena() {
        guard let arenaSprite = childNode(withName: GameConstants.TetrisArenaKey) as? SKSpriteNode else {
            return
        }
        let arenaComponent = ArenaComponent(withSpriteNode: arenaSprite)
        let arenaEntity = ArenaEntity(withComponents: [arenaComponent], withEntityManager: entityManager)
        entityManager.add(entity: arenaEntity)
    }
    
    func initializeScore() {
        guard let scoreLabelNode = childNode(withName: GameConstants.ScoreLabelKey) as? SKLabelNode else {
            return
        }
        let scoreComponent = LabelComponent(withLabelNode: scoreLabelNode)
        let scoreEntity = ScoreEntity(withComponents: [scoreComponent], withEntityManager: entityManager)
        entityManager.add(entity: scoreEntity)
    }
    
    func initializeButtons() {
        initializeLeftButton()
        initializeRightButton()
        initializeDownButton()
        initializeRotateButton()
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
            
            let droppingPolyomino = self.entityManager.arena.droppingPolyomino
            guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.direction = .left
            moveComponent.waitForMoveTime = 0.0
            moveComponent.moveHorizontally()
        }
        
        leftButton.touchUpHandler = {
            [unowned self] in
            
            let droppingPolyomino = self.entityManager.arena.droppingPolyomino
            guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.direction = self.rightButton.buttonDown ? .right : .none
        }
    }
    
    func initializeRightButton() {
        rightButton.isUserInteractionEnabled = true
        
        rightButton.touchDownHandler = {
            [unowned self] in
            
            let droppingPolyomino = self.entityManager.arena.droppingPolyomino
            guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.direction = .right
            moveComponent.waitForMoveTime = 0.0
            moveComponent.moveHorizontally()
        }
        rightButton.touchUpHandler = {
            [unowned self] in
            
            let droppingPolyomino = self.entityManager.arena.droppingPolyomino
            guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.direction = self.leftButton.buttonDown ? .left : .none
        }
    }
    
    func initializeDownButton() {
        downButton.isUserInteractionEnabled = true

        
        downButton.touchDownHandler = {
            [unowned self] in
            
            let droppingPolyomino = self.entityManager.arena.droppingPolyomino
            guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.currentDropInterval = GameConstants.HurriedUpDropInterval
        }
        downButton.touchUpHandler = {
            [unowned self] in
            
            let droppingPolyomino = self.entityManager.arena.droppingPolyomino
            guard let moveComponent = droppingPolyomino?.component(ofType: FixedMoveComponent.self) else {
                return
            }
            
            moveComponent.currentDropInterval = GameConstants.DefaultDropInterval
        }
    }
    
    func initializeRotateButton() {
        rotateButton.isUserInteractionEnabled = true
        rotateButton.touchDownHandler = {
            [unowned self] in
            
            let droppingPolyomino = self.entityManager.arena.droppingPolyomino
            guard let rotationComponent = droppingPolyomino?.component(ofType: RotationComponent.self) else {
                return
            }
            
            guard let collider = droppingPolyomino?.component(ofType: CollisionCheckingComponent.self) else {
                return
            }
            
            if collider.canTurnClockwise() {
                rotationComponent.turnClockwise()
            }
        }
    }
}
