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
    
    var arena: ArenaEntity {
        return getEntity(contains: ArenaComponent.self) as! ArenaEntity
    }
    
    var polyomino: PolyominoEntity? {
        return getEntity(contains: PolyominoComponent.self) as? PolyominoEntity
    }
}

private extension EntityManager {
    func getEntity(contains type: GKComponent.Type) -> GKEntity? {
        for entity in entities {
            if let _ = entity.component(ofType: type) {
                return entity
            }
        }
        return nil
    }
}
