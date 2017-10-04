import SpriteKit

// MARK: SKSpriteButton

/// (SeriousKit) SKSpriteButton.
/// This is a special kind of `SKSpriteNode` that behaves like a button.
///
/// User should expect similar ergonomics when using `UIButton`.
public class SKSpriteButton: SKSpriteNode {
    
    public enum Status {
        case normal
        case tapped
    }
    
    public typealias EventHandler = (Set<UITouch>, UIEvent?) -> Void

    /// Set this variable if you want to display a
    /// different texture when the button is tapped.
    public var tappedTexture: SKTexture?
    
    /// Color to display when a button is tapped.
    public var tappedColor: UIColor?
    
    /// Button status represented by `SKSpriteButton.Status`.
    public var status: Status = .normal {
        didSet {
            switch status {
            case .normal: showNormalAppearance()
            case .tapped: showTappedAppearance()
            }
        }
    }
    
    internal var storedNormalColor: UIColor?
    
    internal var storedNormalTexture: SKTexture?

    internal var touchesBeganHandlers = [EventHandler]()
    
    internal var touchesEndedHandlers = [EventHandler]()
    
    internal var touchesCancelledHandlers = [EventHandler]()
    
    internal var touchesMovedHandlers = [EventHandler]()
    
    public func addTouchesBeganHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesBeganHandlers.append(handler)
    }
    
    public func addTouchesEndedHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesEndedHandlers.append(handler)
    }
    
    public func addTouchesCancelledHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesCancelledHandlers.append(handler)
    }
}

// MARK: - Touch events.
extension SKSpriteButton {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        status = .tapped
        touchesBeganHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        status = .normal
        touchesEndedHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        status = .normal
        touchesCancelledHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        status = .tapped
        touchesMovedHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
}

// MARK: - Helper Methods
private extension SKSpriteButton {
    
    func showNormalAppearance() {
        showNormalColor()
        showNormalTexture()
    }
    
    func showTappedAppearance() {
        showTappedColor()
        showTappedTexture()
    }
    
    func showNormalColor() {
        if let storedNormalColor = storedNormalColor {
            color = storedNormalColor
        }
    }
    
    func showNormalTexture() {
        if let storedNormalTexture = storedNormalTexture {
            texture = storedNormalTexture
        }
    }
    
    func showTappedColor() {
        if let tappedColor = tappedColor {
            storedNormalColor = color
            color = tappedColor
        }
    }
    
    func showTappedTexture() {
        if let tappedTexture = tappedTexture {
            storedNormalTexture = texture
            texture = tappedTexture
        }
    }
}
