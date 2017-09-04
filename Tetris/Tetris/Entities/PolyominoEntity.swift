import GameplayKit
import SpriteKit

class PolyominoEntity: GKEntity {
    
    init(withComponents components: [GKComponent]) {
        super.init()
        _ = components.map { addComponent($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        _ = components.map {
            $0.update(deltaTime: seconds)
        }
    }

}
