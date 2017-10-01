import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let entityManager = EntityManager()
    
    lazy var stateMachine: GKStateMachine = {
        let playState = PlayState(withGame: self)
        let pauseState = PauseState(withGame: self)
        return GKStateMachine(states: [playState, pauseState])
    }()
    
    var hitSound = SKAction.playSoundFileNamed(GameConstants.HitSoundFileName, waitForCompletion: false)
    
    var audioNode: SKAudioNode {
        return childNode(withName: GameConstants.GameStartSceneMusic) as! SKAudioNode
    }
    
    var pauseNode: SKSpriteNode {
        return childNode(withName: GameConstants.PauseAreaKey) as! SKSpriteNode
    }
    
    var lastUpdateTime: TimeInterval = 0
}

// MARK: - Lifecycle methods
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        stateMachine.update(deltaTime: deltaTime)
    }
    
    override func didMove(to view: SKView) {
        initializeSpawnArea()
        initializeArena()
        initializeButtons()
        initializeScore()
        
        entityManager.spawnArea.spawnPolyominoEntity(withDelegate: self)
        entityManager.spawnArea.stagePolyomino()
        entityManager.spawnArea.spawnPolyominoEntity(withDelegate: self)
        
        stateMachine.enter(PauseState.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard stateMachine.currentState is PauseState else {
            return
        }
        for touch in touches {
            if pauseNode.frame.contains(touch.location(in: self)) {
                stateMachine.enter(PlayState.self)
            }
        }
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

extension GameScene: PolyominoEventDelegate {
    func didOverflow() {
        guard let gameOverScene = SKScene(fileNamed: GameConstants.GameOverScene) as? GameOverScene else {
            return
        }
        gameOverScene.score = entityManager.scoreLabel.score
        gameOverScene.scaleMode = .aspectFit
        let transition = SKTransition.moveIn(with: .right, duration: 0.5)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
}

// MARK: - Initializations
private extension GameScene {
    
    func playBackgroundMusic() {
        audioNode.run(SKAction.play())
    }
    
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
        let cropComponent = CroppingComponent()
        cropComponent.add(maskNode: SKSpriteNode(imageNamed: GameConstants.ArenaMaskImageName))
        arenaSprite.addChild(cropComponent.cropNode)
        let rules = [
            GKRule(predicate: NSPredicate {
                (obj, _) in
                guard let score = (obj as! GKRuleSystem).state[GameConstants.CurrentScoreKey] as? Int else {
                    return false
                }
                return score % GameConstants.NumScoreBeforeProceeding == 0
            }, assertingFact: GameConstants.ProceedToNextLevelFact as NSObjectProtocol, grade: 1.0)
        ]
        let ruleComponent = RuleComponent(withRules: rules)
        let arenaEntity = ArenaEntity(withComponents: [arenaComponent,
                                                       ruleComponent,
                                                       cropComponent], withEntityManager: entityManager)
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
        initializePauseButton()
    }

}

// MARK: - Buttons
private extension GameScene {
    
    var leftButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.LeftButtonKey) as! ButtonSpriteNode
    }
    
    var rightButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.RightButtonKey) as! ButtonSpriteNode
    }
    
    var downButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.DownButtonKey) as! ButtonSpriteNode
    }
    
    var rotateButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.RotateButtonKey) as! ButtonSpriteNode
    }
    
    var pauseButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.PauseButtonKey) as! ButtonSpriteNode
    }
    
    func initializeLeftButton() {
        leftButton.isUserInteractionEnabled = true

        leftButton.touchDownHandler = {
            [unowned self] in
            
            guard self.stateMachine.currentState is PlayState else {
                return
            }
            
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
            
            guard self.stateMachine.currentState is PlayState else {
                return
            }
            
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
            
            switch self.stateMachine.currentState {
            case is PlayState:
                moveComponent.direction = self.leftButton.buttonDown ? .left : .none
            default: break
            }
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
            
            moveComponent.currentDropInterval = self.entityManager.arena.currentDropInterval
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
    
    func initializePauseButton() {
        pauseButton.isUserInteractionEnabled = true
        pauseButton.touchDownHandler = {
            [unowned self] in
            self.stateMachine.enter(PauseState.self)
        }
    }
}
