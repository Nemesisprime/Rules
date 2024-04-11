//
//  Rule
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

/// A rule to be used in the context of a rule system, with a predicate to be tested
/// and an action to be executed when the test succeeds.
open class Rule<State, Fact: Hashable> {

    /// The importance of the rule relative to others in a rule system’s agenda.
    var salience: Int = 0

    private let predicate: (RuleEditor<State, Fact>) -> Bool
    private let action: (RuleEditor<State, Fact>) -> Void

    public init(salience: Int = 0,
                predicate: @escaping (RuleEditor<State, Fact>) -> Bool,
                action: @escaping (RuleEditor<State, Fact>) -> Void) {
        self.salience = salience
        self.predicate = predicate
        self.action = action
    }

    open func evaluatePredicate(editor: RuleEditor<State, Fact>) -> Bool {
        return predicate(editor)
    }

    open func performAction(editor: RuleEditor<State, Fact>) {
        action(editor)
    }
}
