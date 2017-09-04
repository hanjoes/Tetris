import GameplayKit
import SpriteKit

class PolyominoEntity: TetrisEntity {
    
    override func update(deltaTime seconds: TimeInterval) {
        _ = components.map {
            $0.update(deltaTime: seconds)
        }
    }
    
    func pourIntoArena() {
        guard let polyomino = entityManager.polyomino else {
            return
        }

        guard let polyominoComponent = polyomino.component(ofType: PolyominoComponent.self) else {
            return
        }
        
        let arena = entityManager.arena
        
        for spriteComponent in polyominoComponent.spriteComponents {
            let polyominoHeight = spriteComponent.sprite.frame.minY
            let arenaBottom = -arena.arenaComponent.sprite.frame.height / 2
            let rowIndex = Int((polyominoHeight - arenaBottom) / arena.scale)
            arena.nodesBuckets[rowIndex].append(spriteComponent.sprite)
        }
    }
}
