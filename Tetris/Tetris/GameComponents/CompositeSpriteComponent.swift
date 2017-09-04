import GameplayKit
import SpriteKit

/// A composite sprite component can contain mutliple other sprite components.
class CompositeSpriteComponent: GKComponent {
    
    var spriteComponents = [SpriteComponent]()
    
    /// The position of the piece relative to the parent.
    var position: CGPoint {
        get {
            return spriteComponents.first?.sprite.position ?? CGPoint.zero
        }
        
        set {
            let translation = position.translation(to: newValue)
            for child in spriteComponents {
                child.sprite.position = child.position.translate(by: translation)
            }
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        _ = spriteComponents.map { $0.update(deltaTime: seconds) }
    }
    
    func add(spriteComponent component: SpriteComponent) {
        spriteComponents.append(component)
    }
    
    func reparent(toNewParent parent: SKNode) {
        _ = spriteComponents.map {
            $0.reparent(toNewParent: parent)
        }
    }
    
}
