import GameplayKit

class RuleComponent: GKComponent {
    let ruleSystem = GKRuleSystem()
    
    init(withRules rules: [GKRule]) {
        super.init()
        rules.forEach {
            ruleSystem.add($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
