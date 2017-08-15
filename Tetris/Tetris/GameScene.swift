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
    
    /// Last time in Double the polyomino in the arena dropped.
    var lastDropTime: Double = 0
    
    /// There will be a preparing polyomino anytime when the game is in progress.
    var preparingPolyomino: SKPolyomino! {
        didSet {
            if preparingPolyomino == nil {
                spawnPreparingPolyomino()
            }
        }
    }
    
    /// Similar to `preparingPolyomino` there will always be one dropping.
    var droppingPolyomino: SKPolyomino! {
        didSet {
            droppingPolyomino.move(to: arena)
            droppingPolyomino.position = CGPoint(x: -scale, y: arena.frame.height / 2)
        }
    }
    
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
        
        if currentTime - lastDropTime >= GameConstants.DefaultDropInterval {
            updateDroppingPolyomino()
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    /// Update the dropping polyomino, this method will ensure we have a
    /// polyomino in the arena and preparing polyomino will be updated after
    /// we used the polyomino in spawning area.
    func updateDroppingPolyomino() {
        if droppingPolyomino == nil {
            droppingPolyomino = preparingPolyomino
            preparingPolyomino = nil
        }
        
        droppingPolyomino.drop()
    }
}
