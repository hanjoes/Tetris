import GameplayKit

class ArenaEntity: TetrisEntity {
    
    /// The buckets by row, containing stable nodes.
    var nodesBuckets = [[SKNode]]()
    
    var currentLevel = 0
    
    var currentDropInterval: Double {
        return max(GameConstants.DefaultDropInterval - Double(currentLevel) / 10, GameConstants.MinimumDropInterval)
    }
    
    var arenaComponent: ArenaComponent {
        return component(ofType: ArenaComponent.self)!
    }
    
    var ruleComponent: RuleComponent {
        return component(ofType: RuleComponent.self)!
    }
    
    weak var droppingPolyomino: PolyominoEntity?
    
    var scale: CGFloat {
        return arenaComponent.sprite.frame.width / GameConstants.HorizontalCellNum
    }
    
    override init(withComponents components: [GKComponent], withEntityManager entityManager: EntityManager) {
        super.init(withComponents: components, withEntityManager: entityManager)
        initializeBuckets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearIfFull() {
        let fullRowNum = Int(arenaComponent.sprite.frame.width / scale)
        var rowsCleared = 0
        for rowIndex in 0..<nodesBuckets.count {
            let row = nodesBuckets[rowIndex]
            if row.count == fullRowNum {
                _ = row.map { $0.removeFromParent() }
                nodesBuckets[rowIndex].removeAll()
                rowsCleared += 1
            }
        }
        compressRows()
        entityManager.scoreLabel.score += rowsCleared
        
        if rowsCleared > 0 {
            ruleComponent.ruleSystem.state[GameConstants.CurrentScoreKey] = entityManager.scoreLabel.score

            ruleComponent.ruleSystem.reset()
            ruleComponent.ruleSystem.evaluate()
            if ruleComponent.ruleSystem.grade(forFact: GameConstants.ProceedToNextLevelFact as NSObjectProtocol) > 0 {
                currentLevel += 1
            }
        }
    }
    
    func compressRows() {
        let numRows = Int(arenaComponent.sprite.frame.height / scale)
        for rowIndex in 0..<numRows {
            var currentRow = rowIndex
            if nodesBuckets[currentRow].isEmpty {
                while nodesBuckets[currentRow].isEmpty {
                    currentRow += 1
                    if currentRow == numRows {
                        return
                    }
                }
                descend(rowIndex: currentRow, by: currentRow - rowIndex)
                nodesBuckets[rowIndex] = nodesBuckets[currentRow]
                nodesBuckets[currentRow].removeAll()
            }
        }
    }
    
    
    func descend(rowIndex index: Int, by level: Int) {
        guard index >= 0 && index < nodesBuckets.count else {
            return
        }
        let row = nodesBuckets[index]
        for node in row {
            node.position = node.position.translate(by: CGPoint(x: 0, y: -scale * CGFloat(level)))
        }
    }
}

private extension ArenaEntity {
    
    func initializeBuckets() {
        let numRow = Int(arenaComponent.sprite.frame.height / scale)
        nodesBuckets = [[SKNode]](repeating: [SKNode](), count: numRow)
    }
}
