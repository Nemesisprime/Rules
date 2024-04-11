//
//  RuleSystem
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

/// A RuleSystem object manages a list of rules
class RuleSystem<State, Fact: Hashable> {

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

    // MARK: Evaluate

    public func evaluate(state: State) -> RuleResult<State, Fact> {
        let ruleEditor = RuleEditor<State, Fact>(state: state)
        let rulesToRun = self.agenda
        for rule in rulesToRun {
            if rule.evaluatePredicate(editor: ruleEditor) {
                rule.performAction(editor: ruleEditor)
            }
        }

        return ruleEditor.makeResult()
    }

    var agenda: [Rule<State, Fact>] {
        return self.rules.sorted { $0.salience > $1.salience }
    }
}
