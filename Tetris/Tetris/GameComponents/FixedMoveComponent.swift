import GameplayKit
import SpriteKit

class FixedMoveComponent: GKComponent {
    var lastMoveTime: CFTimeInterval = 0.0
    var scale: CGFloat
    
    init(moveWithScale scale: CGFloat) {
        self.scale = scale
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func move(component: Movable, withTranslation translation: CGPoint) {
        component.move(withTranslation: translation)
    }
}

