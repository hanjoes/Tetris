import GameplayKit

class ScoreEntity: TetrisEntity {
    
    var score = 0 {
        didSet {        
            guard let labelComponent = component(ofType: LabelComponent.self) else {
                return
            }
            
            labelComponent.labelNode.text = "\(score)"
        }
    }
    
    func updateScore(withRowsCleared rowsCleared: Int) {
        guard rowsCleared > 0 else {
            return
        }

        score += rowsCleared
    }
}
