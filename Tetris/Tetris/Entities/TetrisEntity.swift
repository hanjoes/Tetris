import GameplayKit

class TetrisEntity: GKEntity {
    
    var entityManager: EntityManager
    
    init(withComponents components: [GKComponent], withEntityManager entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        _ = components.map { addComponent($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
