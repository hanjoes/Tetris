import GameplayKit
import SpriteKit


/// GKComponent that wraps a `SKSpriteNode`.
class SpriteComponent: GKComponent {
    
    /// The wrapped `SKSpriteNode`.
    var sprite: SKSpriteNode
    
    var position: CGPoint {
        get {
            return sprite.position
        }
        
        set {
            sprite.position = newValue
        }
    }
    
    convenience init(withTexture texture: SKTexture?) {
        self.init(withSpriteNode: SKSpriteNode(texture: texture))
    }
    
    init(withSpriteNode spriteNode: SKSpriteNode) {
        self.sprite = spriteNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reparent(toNewParent parent: SKNode) {
        sprite.removeFromParent()
        parent.addChild(sprite)
    }
}
