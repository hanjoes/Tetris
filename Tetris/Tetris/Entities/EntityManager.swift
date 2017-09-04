import GameplayKit

class EntityManager {
    var entities = Set<GKEntity>()
    
    func add(entity: GKEntity) {
        entities.insert(entity)
    }
    
    func remove(entity: GKEntity) {
        entity.removeComponent(ofType: CompositeSpriteComponent.self)
        entity.removeComponent(ofType: SpriteComponent.self)
        entities.remove(entity)
    }
    
    func update(deltaTime seconds: TimeInterval) {
        _ = entities.map {
            $0.update(deltaTime: seconds)
        }
    }
}
