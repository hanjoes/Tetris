import GameplayKit

class LabelComponent: GKComponent {
    var labelNode: SKLabelNode
    
    init(withLabelNode labelNode: SKLabelNode) {
        self.labelNode = labelNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
