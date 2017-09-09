import SpriteKit

class GameOverScene: SKScene {
    var score = 0
    
    var entityManager = EntityManager()
}

// MARK: - Lifecycles
extension GameOverScene {
    override func didMove(to view: SKView) {
        initializeGameOverScore()
    }
}

// MARK: - Initializers
extension GameOverScene {
    func initializeGameOverScore() {
        guard let scoreLabel = childNode(withName: GameConstants.EndgameScoreLabelKey) as? SKLabelNode else {
            return
        }
        let labelComponent = LabelComponent(withLabelNode: scoreLabel)
        let scoreEntity = ScoreEntity(withComponents: [labelComponent], withEntityManager: entityManager)
        scoreEntity.score = score
    }
}
