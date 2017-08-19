import SpriteKit
import GameplayKit


// TODO: - Switch to GameplayKit
class GameScene: SKScene {
    
    /// The arena where we actually play the game.
    var arena: SKNode {
        return childNode(withName: GameConstants.TetrisArenaKey)!
    }
    
    /// The area where we spawn polyominoes.
    var spawnArea: SKNode {
        return childNode(withName: GameConstants.SpawnAreaKey)!
    }
    
    /// Nodes that will not move any more.
    var stableNodes = [SKNode]()
    
    var leftButton: SKNode {
        return childNode(withName: GameConstants.LeftButtonKey)!
    }
    
    var leftButtonDown = false
    
    var leftButtonTouches = Set<UITouch>() {
        didSet {
            if !leftButtonTouches.isEmpty {
                leftButtonDown = true
                droppingPolyomino.direction = .left
                moveHorizontally()
            }
            else {
                leftButtonDown = false
                droppingPolyomino.direction = rightButtonDown ? .right : .none
            }
        }
    }
    
    var rightButton: SKNode {
        return childNode(withName: GameConstants.RightButtonKey)!
    }
    
    var rightButtonDown = false
    
    var rightButtonTouches = Set<UITouch>() {
        didSet {
            if !rightButtonTouches.isEmpty {
                rightButtonDown = true
                droppingPolyomino.direction = .right
                moveHorizontally()
            }
            else {
                rightButtonDown = false
                droppingPolyomino.direction = leftButtonDown ? .left : .none
            }
        }
    }
    
    
    var downButton: SKNode {
        return childNode(withName: GameConstants.DownButtonKey)!
    }
    
    var downButtonTouches = Set<UITouch>() {
        didSet {
            if !downButtonTouches.isEmpty {
            }
            else {
            }
        }
    }
    
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
        initializePolyominoCreator()
    }
    
    override func update(_ currentTime: TimeInterval) {
        spawnPreparingPolyomino()
        updateDroppingPolyomino(currentTime)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            if leftButton.contains(touchPoint) {
                leftButtonTouches.insert(touch)
            }
            else if rightButton.contains(touchPoint) {
                rightButtonTouches.insert(touch)
            }
            else if downButton.contains(touchPoint) {
                downButtonTouches.insert(touch)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if leftButtonTouches.contains(touch) {
                _ = leftButtonTouches.remove(touch)
            }
            if rightButtonTouches.contains(touch) {
                _ = rightButtonTouches.remove(touch)
            }
            if downButtonTouches.contains(touch) {
                _ = downButtonTouches.remove(touch)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

private extension GameScene {
    
    /// Initializes the creator for `Polyomino`.
    func initializePolyominoCreator() {
        creator = PolyominoCreator(forCellNum: GameConstants.DefaultComplexity)
    }
    
    /// Spawn a preparing `Polyomino` at the spawning area.
    func spawnPreparingPolyomino() {
        guard preparingPolyomino == nil else {
            return
        }
        
        let prototype = creator.randomPolyomino
        preparingPolyomino = SKPolyomino(from: prototype, withScale: scale)
        let spawnArea = childNode(withName: GameConstants.SpawnAreaKey)!
        preparingPolyomino.add(to: spawnArea)
    }
    
    func moveHorizontally() {
        switch droppingPolyomino.direction {
        case .left:
            if canMoveLeft {
                droppingPolyomino.moveLeft()
            }
        case .right:
            if canMoveRight {
                droppingPolyomino.moveRight()
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
            lastMoveTime = currentTime
            moveHorizontally()
        }
        
        if currentTime - lastDropTime >= GameConstants.DefaultDropInterval {
            lastDropTime = currentTime
            if canDrop {
                droppingPolyomino.drop()
            }
            else {
                stableNodes = stableNodes + droppingPolyomino.spriteNodes
                stagePolyomino()
            }
        }
    }
    
    func stagePolyomino() {
        droppingPolyomino = preparingPolyomino
        droppingPolyomino.move(to: arena)
        droppingPolyomino.position = CGPoint(x: -scale, y: arena.frame.height / 2)
        preparingPolyomino = nil
    }

    var canDrop: Bool {
        return droppingPolyomino.spriteNodes.filter {
            var noHit = true
            let nextPosition = $0.frame.origin.translate(by: CGPoint(x: 0, y: -scale))
            if nextPosition.y < -(arena.frame.height / 2) {
                noHit = false
            }
            else {
                for stableNode in stableNodes {
                    if nextPosition == stableNode.frame.origin {
                        noHit = false
                        break
                    }
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
                for stableNode in stableNodes {
                    if nextPosition == stableNode.frame.origin {
                        noHit = false
                        break
                    }
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
                for stableNode in stableNodes {
                    if nextPosition == stableNode.frame.origin {
                        noHit = false
                        break
                    }
                }
            }
            return noHit
        }.count == droppingPolyomino.spriteNodes.count
    }
}
