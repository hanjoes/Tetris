import GameplayKit
import SpriteKit

/// Special case of a `CompositeSpriteComponent`.
/// Some of the polyomino-specific fields (for e.g.: scale, prototype)
/// should just fit into PolyominoEntity, but instead I put them into
/// a component for better reusability.
class PolyominoComponent: CompositeSpriteComponent {
    
    /// Scale of each cell in the instantiated polyomino.
    var scale: CGFloat
    
    /// The prototype from which this component is built.
    var prototype: Polyomino
    
    /// The point around which we rotate.
    var anchorPoint: CGPoint {
        let protoAnchorPointX = prototype.anchorPoint.x
        let protoAnchorPointY = prototype.anchorPoint.y
        var initialMidPoint = CGPoint(x: protoAnchorPointX * scale, y: protoAnchorPointY * scale)

        /// The anchor point could be moved because dropping and horizontal movement.
        if let fixedMoveComponent = entity?.component(ofType: FixedMoveComponent.self) {
            initialMidPoint = initialMidPoint.translate(by: fixedMoveComponent.accumulatedTranslation)
        }

        return initialMidPoint
    }
    
    /// Initializes a `PolyominoComponent` with the given texture (if any), scale and prototype.
    /// A prototype should be a `Polyomino` with unit scale.
    ///
    /// - Parameters:
    ///   - texture: Texture for cells in the polyomino
    ///   - scale: length of the side in the cells
    ///   - prototype: a `Polyomino` object serve as prototype
    init(withTexture texture: SKTexture?, withScale scale: CGFloat, withPrototype prototype: Polyomino) {
        self.scale = scale
        self.prototype = prototype
        super.init()
        _ = prototype.points.map {
            let skNode = SKSpriteNode(texture: texture, color: .blue, size: CGSize(width: scale, height: scale))
            skNode.position = CGPoint(x: $0.x * scale, y: $0.y * scale)
            skNode.anchorPoint = CGPoint(x: 0, y: 0)
            skNode.texture = texture
            self.spriteComponents.append(SpriteComponent(withSpriteNode: skNode))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
