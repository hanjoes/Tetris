import GameplayKit
import SpriteKit


/// Horizontal movement direction of this polyomino.
///
/// - left: moving left
/// - right: moving right
/// - none: no horizontal movement
enum HorizontalDirection {
    case left
    case right
    case none
}

protocol FixedMoveComponentDelegate {
    func didStablize()
}

class FixedMoveComponent: GKComponent {
    
    var waitForDropTime: TimeInterval = 0.0
    
    var waitForMoveTime: TimeInterval = 0.0
    
    var direction: HorizontalDirection = .none
    
    var currentDropInterval = GameConstants.DefaultDropInterval
    
    var accumulatedTranslation = CGPoint.zero
    
    var delegate: FixedMoveComponentDelegate? = nil
    
    var collisionComponent: CollisionCheckingComponent? {
        return entity?.component(ofType: CollisionCheckingComponent.self)
    }
    
    func moveHorizontally() {
        guard let polyominoComponent = entity?.component(ofType: PolyominoComponent.self) else {
            return
        }
        
        guard let collider = collisionComponent else {
            return
        }
        
        switch direction {
        case .left:
            if collider.canMoveLeft {
                move(by: CGPoint(x: -polyominoComponent.scale, y: 0))
            }
        case .right:
            if collider.canMoveRight {
                move(by: CGPoint(x: polyominoComponent.scale, y: 0))
            }
        default:
            break
        }
    }
    
    func move(by translation: CGPoint) {
        guard let polyominoComponent = entity?.component(ofType: PolyominoComponent.self) else {
            return
        }
        
        _ = polyominoComponent.spriteComponents.map {
            $0.sprite.position = $0.sprite.position.translate(by: translation)
        }
        accumulatedTranslation = accumulatedTranslation.translate(by: translation)
    }
    
    func drop() {
        guard let collider = collisionComponent else {
            return
        }
        
        guard let polyominoComponent = entity?.component(ofType: PolyominoComponent.self) else {
            return
        }
        
        if collider.canDrop {
            move(by: CGPoint(x: 0, y: -polyominoComponent.scale))
        }
        else {
            delegate?.didStablize()
        }
    }
    
}

extension FixedMoveComponent {
    override func update(deltaTime seconds: TimeInterval) {
        waitForDropTime += seconds
        if waitForDropTime >= currentDropInterval {
            drop()
            waitForDropTime = waitForDropTime.truncatingRemainder(dividingBy: currentDropInterval)
        }
        
        waitForMoveTime += seconds
        if waitForMoveTime >= GameConstants.HorizontalMovingInterval {
            moveHorizontally()
            waitForMoveTime = waitForMoveTime.truncatingRemainder(dividingBy: GameConstants.HorizontalMovingInterval)
        }
    }
}
