import GameplayKit


class SpawnAreaEntity: TetrisEntity {
    
    var blockTextureAtlas = [
        SKTextureAtlas(named: GameConstants.BlueBlockAtlasName),
        SKTextureAtlas(named: GameConstants.GreenBlockAtlasName),
        SKTextureAtlas(named: GameConstants.YellowBlockAtlasName),
        SKTextureAtlas(named: GameConstants.PinkBlockAtlasName)
    ]
    
    let creator = PolyominoCreator<Tetris>()
    
    var preparingPolyomino: PolyominoEntity?
    
    func spawnPolyominoEntity(withDelegate delegate: GameScene) {
        guard preparingPolyomino == nil else {
            return
        }
        
        guard let spawnAreaComponent = component(ofType: SpawnAreaComponent.self) else {
            return
        }
        
        let arena = entityManager.arena
        let scale = arena.scale
        let prototypes = creator.allPossible
        
        let randomIndex = Int(arc4random() % UInt32(prototypes.count))
        let chosenPrototype = prototypes[randomIndex]
        let currentLevel = entityManager.arena.currentLevel
        let chosenAtlas = blockTextureAtlas[currentLevel % blockTextureAtlas.count]
        let chosenTextureName = chosenAtlas.textureNames[randomIndex % chosenAtlas.textureNames.count]
        let chosenTexture = chosenAtlas.textureNamed(chosenTextureName)
        
        let polyominoComponent = PolyominoComponent(withTexture: chosenTexture, withScale: scale, withPrototype: chosenPrototype)
        let rotationComponent = RotationComponent()
        let collisionCheckingComponent = CollisionCheckingComponent()
        let moveComponent = FixedMoveComponent()
        moveComponent.delegate = delegate
        
        let newPolyominoEntity = PolyominoEntity(withComponents: [polyominoComponent,
                                                                  moveComponent,
                                                                  collisionCheckingComponent,
                                                                  rotationComponent],
                                                 withEntityManager: entityManager)
        newPolyominoEntity.eventDelegate = delegate
        preparingPolyomino = newPolyominoEntity
        
        polyominoComponent.reparent(toNewParent: spawnAreaComponent.sprite)
        let midPointX = polyominoComponent.prototype.centerPoint.x
        let midPointY = polyominoComponent.prototype.centerPoint.y
        let midPoint = CGPoint(x: midPointX * scale, y: midPointY * scale)
        polyominoComponent.position = polyominoComponent.position.translate(by: midPoint.translation(to: CGPoint.zero))
    }
    
    func stagePolyomino() {
        guard preparingPolyomino != nil else {
            return
        }
        
        entityManager.arena.droppingPolyomino = preparingPolyomino
        
        guard let droppingPolyomino = entityManager.arena.droppingPolyomino else {
            return
        }
        
        entityManager.entities.insert(droppingPolyomino)
        preparingPolyomino = nil
        
        guard let polyominoComponent = droppingPolyomino.component(ofType: PolyominoComponent.self) else {
            return
        }
        let arena = entityManager.arena
        let scale = arena.scale
        let cropNode = arena.croppingComponent.cropNode
        polyominoComponent.reparent(toNewParent: cropNode)
        polyominoComponent.position = CGPoint.zero
        guard let fixedMoveComponent = droppingPolyomino.component(ofType: FixedMoveComponent.self) else {
            return
        }
        let arenaNode = arena.arenaComponent.sprite
        fixedMoveComponent.move(by: polyominoComponent.position.translation(to: CGPoint(x: -scale, y: arenaNode.frame.height / 2)))
    }
    
}

