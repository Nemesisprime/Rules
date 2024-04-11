//
//  RuleResult
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

class RuleResult<State, Fact: Hashable> {

    /// An immutable copy of the state associated with the evaluated rule result
    let state: State

    /// A raw copy of the facts and grades generated from the evaluation
    private var assertedFactsAndGrades: [Fact: Double]

    /// The list of facts claimed by the rule system
    var facts: [Fact] {
        return assertedFactsAndGrades.keys.map { $0 }
    }

    /// Public Initializer
    init(state: State,
         assertedFactsAndGrades: [Fact: Double]) {
        self.state = state
        self.assertedFactsAndGrades = assertedFactsAndGrades
    }

    /// Returns the membership grade of the specified fact.
    ///
    /// If the specified fact is not in the facts array, this method returns 0.0.
    public func grade(for fact: Fact) -> Double {
        return self.assertedFactsAndGrades[fact] ?? 0.0
    }
}

