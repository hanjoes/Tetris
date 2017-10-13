import SpriteKit
import AVFoundation
import SKSpriteButton

class GameStartScene: SKScene {
    var audioNode: SKAudioNode {
        return childNode(withName: GameConstants.GameStartSceneMusic) as! SKAudioNode
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
    
    var gameStartButton: SKSpriteButton {
        return childNode(withName: GameConstants.GameStartButtonKey)! as! SKSpriteButton
    }
    
    func initializeStartButton() {
        gameStartButton.moveType = .alwaysHeld
        gameStartButton.tappedTexture = SKTexture(imageNamed: GameConstants.GameStartButtonTappedTextureName)
        gameStartButton.addTouchesUpHandler {
            [unowned self]
            (_, _) in
            
            let gameScene = SKScene(fileNamed: GameConstants.GameScene)!
            gameScene.scaleMode = .aspectFit
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
}

// MARK: - Audio
private extension GameStartScene {
    func playBackgroundMusic() {
        audioNode.run(SKAction.play())
    }
}
