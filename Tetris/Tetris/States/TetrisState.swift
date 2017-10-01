import GameplayKit

class TetrisState: GKState {

    let game: GameScene
    
    init(withGame game: GameScene) {
        self.game = game
        super.init()
    }
}
