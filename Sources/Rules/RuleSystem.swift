//
//  RuleSystem
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

/// A RuleSystem object manages a list of rules
class RuleSystem<State, Fact> {


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

    public func evaluate(state: State) -> Outcome<State, Fact> {
        return Outcome(state: state)
    }


}

class RuleEditor<State, Fact> {
    var state: State

    init(state: State) {
        self.state = state
    }

    public func assert(_ fact: Fact, grade: Double) {

    }

    public func retract(_ fact: Fact, grade: Double) {

    }
}


class Outcome<State, Fact> {
    var state: State
    var facts = [Any]()

    init(state: State) {
        self.state = state
    }

    public func grade(for: Fact) -> Double {
        return 0.0
    }
}
