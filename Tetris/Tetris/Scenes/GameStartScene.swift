import SpriteKit
import AVFoundation

class GameStartScene: SKScene {
    var audioNode: SKAudioNode {
        return childNode(withName: "background_music") as! SKAudioNode
    }
}

// MARK: - Lifecycles
extension GameStartScene {
    override func didMove(to view: SKView) {
        initializeStartButton()
        playBackgroundMusic()
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
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(gameScene, transition: transition)
        }
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        let flash = SKAction.sequence([fadeOut, fadeIn])
        gameStartButton.run(SKAction.repeatForever(flash))
    }
}

// MARK: - Audio
private extension GameStartScene {
    func playBackgroundMusic() {
        audioNode.run(SKAction.play())
    }
}
