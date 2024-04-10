//
//  Rule
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

/// A rule
class Rule<State, Fact> {

    /// The importance of the rule relative to others in a rule system’s agenda.
    var salience: Int = 0

    init(salience: Int = 0,
         predicate: (RuleEditor<State, Fact>) -> Bool,
         action: (RuleEditor<State, Fact>) -> Void) {
        self.salience = salience
    }

//    func evaluatePredicate(in: RuleSystem<State>) -> Bool {
//        return false
//    }
//
//    func performAction(in: RuleSystem<State>) {
//
//    }

}
