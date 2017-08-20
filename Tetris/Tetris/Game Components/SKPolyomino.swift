import SpriteKit

/// An SKPolyomino is an `SKSpriteNode` that instantiated
/// a polyomino.
///
/// By "instantiate" I mean it's no longer
/// represented by a sequence of `CGPoints` but has position
/// and scale in our game scene.
struct SKPolyomino {
    
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

    /// Child sprite nodes that this piece is composed of.
    var spriteNodes: [SKSpriteNode]
    
    /// The prototype based on which this polyomino is built.
    let prototype: Polyomino
    
    /// The scale of a cell in this piece.
    var scale: CGFloat
    
    /// Total accumulated translation on this polyomino.
    var accumulatedTranslation: CGPoint = CGPoint.zero
    
    /// The position of the piece relative to the parent.
    var position: CGPoint {
        get {
            return spriteNodes.first?.position ?? CGPoint.zero
        }
        
        set {
            let translation = position.translation(to: newValue)
            accumulatedTranslation = accumulatedTranslation.translate(by: translation)
            for child in spriteNodes {
                child.position = child.position.translate(by: translation)
            }
        }
    }
    
    /// The point around which we rotate.
    var anchorPoint: CGPoint {
        let prototypeMidPointX = prototype.midPoint.x
        let prototypeMidPointY = prototype.midPoint.y
        let initialMidPoint = CGPoint(x: prototypeMidPointX * scale, y: prototypeMidPointY * scale)
        return initialMidPoint.translate(by: accumulatedTranslation)
    }
    
    /// Horizontal movement direction.
    var direction: HorizontalDirection = .none
    
    /// Initializer from a prototype and the scale.
    ///
    /// - Parameters:
    ///   - prototype: prototype for building this piece
    ///   - scale: scale of the cells in this piece
    init(from prototype: Polyomino, withScale scale: CGFloat) {
        self.scale = scale
        self.prototype = prototype
        spriteNodes = prototype.points.map {
            let skNode = SKSpriteNode(texture: nil, color: .blue, size: CGSize(width: scale, height: scale))
            skNode.position = CGPoint(x: $0.x * scale, y: $0.y * scale)
            skNode.anchorPoint = CGPoint(x: 0, y: 0)
            return skNode
        }
    }
    
    /// Add this `SKPolyomino` to a parent `SKNode`.
    /// This operation actually appends the child nodes
    /// to the specified `SKNode`.
    ///
    /// - Parameter parent: the `SKNode` to contain all the child nodes
    func add(to parent: SKNode?) {
        if let parent = parent {
            for child in spriteNodes {
                parent.addChild(child)
            }
        }
    }
    
    /// Move this `SKPolyomino` to another parent.
    /// This method is called when we want to move a polyomino
    /// from spawning area to arena.
    ///
    /// - Parameter parent: the new parent
    func move(to parent: SKNode?) {
        if let parent = parent {
            for child in spriteNodes {
                child.removeFromParent()
                parent.addChild(child)
            }
        }
    }
    
    mutating func move(by translation: CGPoint) {
        accumulatedTranslation = accumulatedTranslation.translate(by: translation)
        for child in spriteNodes {
            child.position = child.position.translate(by: translation)
        }
    }
    
    func turn(by translations: [CGPoint]) {
        guard translations.count == spriteNodes.count else {
            return
        }
        
        for index in 0..<translations.count {
            let node = spriteNodes[index]
            node.position = node.position.translate(by: translations[index])
        }
    }
    
    
    func turnClockwise() {
    }
}

private extension SKPolyomino {
    
}

