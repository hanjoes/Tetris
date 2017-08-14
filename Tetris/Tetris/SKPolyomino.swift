import SpriteKit

/// An SKPolyomino is an `SKSpriteNode` that instantiated
/// a polyomino.
///
/// By "instantiate" I mean it's no longer
/// represented by a sequence of `CGPoints` but has position
/// and scale in our game scene.
struct SKPolyomino {
    
    /// The prototype is a `Polyomino` that can be used
    /// as a blueprint to create the `SKPolyomino`.
    var prototype: Polyomino

    /// Child sprite nodes that this piece is composed of.
    var spriteNodes: [SKSpriteNode]
    
    /// The scale of a cell in this piece.
    var scale: CGFloat
    
    /// The position of the piece relative to the parent.
    var position: CGPoint {
        get {
            return spriteNodes.first?.position ?? CGPoint.zero
        }
        set {
            for child in spriteNodes {
                let translation = position.translation(from: newValue)
                child.position = child.position.translate(by: translation)
            }
        }
    }
    
    /// Initializer from a prototype and the scale.
    ///
    /// - Parameters:
    ///   - prototype: prototype for building this piece
    ///   - scale: scale of the cells in this piece
    init(from prototype: Polyomino, withScale scale: CGFloat) {
        self.prototype = prototype
        self.scale = scale
        spriteNodes = self.prototype.points.map {
            let skNode = SKSpriteNode(texture: nil, color: .blue, size: CGSize(width: scale, height: scale))
            skNode.position = CGPoint(x: $0.x * scale, y: $0.y * scale)
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

}
