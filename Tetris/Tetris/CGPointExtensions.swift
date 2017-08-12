import CoreGraphics

// MARK: - Convenience methods for CGPoint.
extension CGPoint {
    
    /// Get the translation from another `CGPoint` to this point.
    ///
    /// - Parameter point: origin `CGPoint`
    /// - Returns: the translation moves origin to this point
    func translation(from point: CGPoint) -> CGPoint {
        return CGPoint(x: x - point.x, y: y - point.y)
    }
    
    /// Get the translation from this point to another `CGPoint`.
    ///
    /// - Parameter point: destination `CGPoint`
    /// - Returns: the translation moves this point to the destination
    func translation(to point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - x, y: point.y - y)
    }
    
    /// Translate this point by the given translation.
    ///
    /// - Parameter translation: the translation applied to this point
    /// - Returns: the destination `CGPoint`
    func translate(by translation: CGPoint) -> CGPoint {
        return CGPoint(x: x + translation.x, y: y + translation.y)
    }
}
