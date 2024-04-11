//
//  RuleSystem
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

/// A RuleSystem object manages a list of rules
public class RuleSystem<State, Fact: Hashable> {

    public init() { }

    // MARK: Managing Rules

    public private(set) var rules = [Rule<State, Fact>]()

    public func add(rule: Rule<State, Fact>) {
        self.rules.append(rule)
    }

    public func add(rules rulesToAdd: [Rule<State, Fact>]) {
        for rule in rulesToAdd {
            self.rules.append(rule)
        }
    }

    public func removeAllRules() {
        self.rules = []
    }

    private func makeAgenda() -> [Rule<State, Fact>] {
        return self.rules.sorted { $0.salience < $1.salience }
    }

    // MARK: Evaluate

    public func evaluate(state: State) -> RuleResult<State, Fact> {
        let ruleEditor = RuleEditor<State, Fact>(state: state)
        
        var agenda = self.makeAgenda()
        var executedRules = [Rule<State, Fact>]()

        var loopInterval = 0

        while true {
            guard agenda.indices.contains(loopInterval) else {
                break
            }

            let rule = agenda[loopInterval]

            // Either we evaluate (and remove the item at the current index)
            // or we bump the index forward
            if rule.evaluatePredicate(editor: ruleEditor) {
                agenda.remove(at: loopInterval)
                executedRules.append(rule)

                rule.performAction(editor: ruleEditor)
                
                // Reset Agenda loop level since we just evaluated a rule.
                loopInterval = 0
            } else {
                loopInterval += 1
            }
        }

        return ruleEditor.makeResult(executedRules: executedRules)
    }
}
