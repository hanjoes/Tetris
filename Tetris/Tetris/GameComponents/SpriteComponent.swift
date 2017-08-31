import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
    var sprite: SKSpriteNode
    
    init(withTexture texture: SKTexture) {
        sprite = SKSpriteNode(texture: texture)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension SpriteComponent: Movable {
    func move(withTranslation translation: CGPoint) {
        sprite.position = sprite.position.translate(by: translation)
    }
}
