import SpriteKit

class ButtonSpriteNode: SKSpriteNode {
    
    typealias ButtonTouchHandler = () -> Void
    
    var buttonDown = false {
        didSet {
            if buttonDown {
                if let touchDownHandler = touchDownHandler {
                    touchDownHandler()
                }
            }
            else {
                if let touchUpHandler = touchUpHandler {
                    touchUpHandler()
                }
            }
        }
    }
    
    var touchDownHandler: ButtonTouchHandler?
    
    var touchUpHandler: ButtonTouchHandler?
    
    var touchesOnNode = Set<UITouch>() {
        didSet {
            if !touchesOnNode.isEmpty {
                buttonDown = true
            }
            else {
                buttonDown = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchesOnNode.insert(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchesOnNode.remove(touch)
        }
    }
}
