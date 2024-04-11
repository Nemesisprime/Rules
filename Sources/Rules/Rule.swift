//
//  Rule
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

/// A rule
class Rule<State, Fact: Hashable> {

    /// The importance of the rule relative to others in a rule system’s agenda.
    var salience: Int = 0

    private let predicate: (RuleEditor<State, Fact>) -> Bool
    private let action: (RuleEditor<State, Fact>) -> Void

    init(salience: Int = 0,
         predicate: @escaping (RuleEditor<State, Fact>) -> Bool,
         action: @escaping (RuleEditor<State, Fact>) -> Void) {
        self.salience = salience
        self.predicate = predicate
        self.action = action
    }

    func evaluatePredicate(editor: RuleEditor<State, Fact>) -> Bool {
        return predicate(editor)
    }

    func performAction(editor: RuleEditor<State, Fact>) {
        action(editor)
    }
}
