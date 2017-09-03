import GameplayKit
import SpriteKit

/// A composite sprite component can contain mutliple other sprite components.
class CompositeSpriteComponent: GKComponent {
    
    var spriteComponents = Set<SpriteComponent>()
    
    override func update(deltaTime seconds: TimeInterval) {
        _ = spriteComponents.map { $0.update(deltaTime: seconds) }
    }
    
    func add(spriteComponent component: SpriteComponent) {
        spriteComponents.insert(component)
    }
    
    func remove(spriteComponent component: SpriteComponent) {
        spriteComponents.remove(component)
    }
    
}
