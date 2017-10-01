import GameplayKit

class PlayState: TetrisState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is PauseState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        game.pauseNode.alpha = 0
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        game.entityManager.update(deltaTime: seconds)
    }
    
}
