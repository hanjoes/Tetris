import GameplayKit
import SpriteKit

class RotationComponent: GKComponent {
    func turnClockwise() {
        guard let polyominoComponent = polyominoComponent else {
            return
        }
        for index in 0..<clockwiseTurnTranslations.count {
            let node = polyominoComponent.spriteComponents[index]
            node.sprite.position = node.sprite.position.translate(by: clockwiseTurnTranslations[index])
        }
    }
    
    var clockwiseTurnTranslations: [CGPoint] {
        guard let polyominoComponent = polyominoComponent else {
            return [CGPoint]()
        }
        
        let anchorPoint = polyominoComponent.anchorPoint
//        print("anchor: \(anchorPoint) points: \(polyominoComponent.spriteComponents.map { $0.sprite.frame.origin})")
        let centeringTranslation = anchorPoint.translation(to: CGPoint.zero)
        return polyominoComponent.spriteComponents.map {
            let x = $0.sprite.frame.minX
            let y = $0.sprite.frame.minY
            let bottomLeftCorner = CGPoint(x: x, y: y)
            let translated = bottomLeftCorner.translate(by: centeringTranslation)
            let rotated = CGPoint(x: translated.y, y: -translated.x)
            let rotationTranslation = translated.translation(to: rotated)
            return rotationTranslation
        }
    }
    
    var polyominoComponent: PolyominoComponent? {
        return entity?.component(ofType: PolyominoComponent.self)
    }
}
