import SpriteKit

class GameStartScene: SKScene {
    
}

// MARK: - Lifecycles
extension GameStartScene {
    override func didMove(to view: SKView) {
        print("inside")
        initializeStartButton()
    }
}

// MARK: - Buttons
private extension GameStartScene {
    
    var gameStartButton: ButtonSpriteNode {
        return childNode(withName: GameConstants.GameStartButtonKey)! as! ButtonSpriteNode
    }
    
    func initializeStartButton() {
        gameStartButton.isUserInteractionEnabled = true
        
        gameStartButton.touchUpHandler = {
            [unowned self] in
            let gameScene = SKScene(fileNamed: GameConstants.GameScene)!
            gameScene.scaleMode = .aspectFit
            let transition = SKTransition.doorway(withDuration: 0.5)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
}
