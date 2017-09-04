import GameplayKit
import SpriteKit

class CollisionCheckingComponent: GKComponent {
    
    var gameScene: GameScene
    
    var bbox: CGRect
    
    // TODO: Really bad to depend on GameScene. refactor into arena entity probably.
    init(inFrame frame: CGRect, inGameScene gameScene: GameScene) {
        self.bbox = frame
        self.gameScene = gameScene
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collide(with point: CGPoint) -> Bool {
        for row in gameScene.nodesBuckets {
            for node in row {
                if node.frame.origin == point {
                    return true
                }
            }
        }
        return false
    }
    
    var canDrop: Bool {
        guard let polyominoComponent = polyominoComponent else {
            return false
        }
        
        return polyominoComponent.spriteComponents.filter {
            var noHit = true
            let nextPosition = $0.sprite.frame.origin.translate(by: CGPoint(x: 0, y: -polyominoComponent.scale))
            if nextPosition.y < -(bbox.height / 2) {
                noHit = false
            }
            else {
                if collide(with: nextPosition) {
                    noHit = false
                }
            }
            return noHit
        }.count == polyominoComponent.spriteComponents.count
    }
    
    var canMoveLeft: Bool {
        guard let polyominoComponent = polyominoComponent else {
            return false
        }
        
        return polyominoComponent.spriteComponents.filter {
            var noHit = true
            let nextPosition = $0.sprite.frame.origin.translate(by: CGPoint(x: -polyominoComponent.scale, y: 0))
            if nextPosition.x < -(bbox.width / 2) {
                noHit = false
            }
            else {
                if collide(with: nextPosition) {
                    noHit = false
                }
            }
            return noHit
        }.count == polyominoComponent.spriteComponents.count
    }
    
    var canMoveRight: Bool {
        guard let polyominoComponent = polyominoComponent else {
            return false
        }
        
        return polyominoComponent.spriteComponents.filter {
            var noHit = true
            let nextPosition = $0.sprite.frame.origin.translate(by: CGPoint(x: polyominoComponent.scale, y: 0))
            if nextPosition.x > (bbox.width / 2 - polyominoComponent.scale) {
                noHit = false
            }
            else {
                if collide(with: nextPosition) {
                    noHit = false
                }
            }
            return noHit
        }.count == polyominoComponent.spriteComponents.count
    }
    
    func canTurnClockwise() -> Bool {
        guard let polyominoComponent = polyominoComponent else {
            return false
        }
        
        guard let rotationComponent = entity?.component(ofType: RotationComponent.self) else {
            return false
        }
        
        let translations = rotationComponent.clockwiseTurnTranslations
        guard translations.count == polyominoComponent.spriteComponents.count else {
            return false
        }

        for index in 0..<translations.count {
            let node = polyominoComponent.spriteComponents[index]
            let translation = translations[index]
            let nextPosition = node.sprite.frame.origin.translate(by: translation)
            if nextPosition.x > (bbox.width / 2 - polyominoComponent.scale) ||
                nextPosition.x < -(bbox.width / 2) ||
                nextPosition.y < -(bbox.height / 2 - polyominoComponent.scale) {
                return false
            }
            else {
                if collide(with: nextPosition) {
                    return false
                }
            }
        }
        return true
    }
    
    var polyominoComponent: PolyominoComponent? {
        return entity?.component(ofType: PolyominoComponent.self)
    }
    
}
