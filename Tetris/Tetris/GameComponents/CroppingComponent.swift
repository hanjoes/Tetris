import GameplayKit

class CroppingComponent: GKComponent {
    var cropNode: SKCropNode
    
    override init() {
        cropNode = SKCropNode()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(childNode node: SKNode) {
        cropNode.addChild(node)
    }
    
    func add(maskNode node: SKNode) {
        cropNode.maskNode = node
    }
}
