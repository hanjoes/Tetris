import SpriteKit

/// An SKPolyomino is an `SKSpriteNode` that instantiated
/// a polyomino.
///
/// By "instantiate" I mean it's no longer
/// represented by a sequence of `CGPoints` but has position
/// and scale in our game scene.
class SKPolyomino: SKSpriteNode {
    
    /// The prototype is a `Polyomino` that can be used
    /// as a blueprint to create the `SKPolyomino`.
    let prototype: Polyomino! = nil
    
}
