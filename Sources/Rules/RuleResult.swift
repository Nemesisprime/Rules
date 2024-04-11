//
//  RuleResult
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

struct RuleResult<State, Fact: Hashable> {

    /// An immutable copy of the state associated with the evaluated rule result
    let state: State

    /// A raw copy of the facts and grades generated from the evaluation
    private let assertedFactsAndGrades: [Fact: Double]

    /// The list of facts claimed by the rule system
    var facts: [Fact] {
        return assertedFactsAndGrades.keys.map { $0 }
    }

    let executedRules: [Rule<State, Fact>]

    init(state: State, 
         assertedFactsAndGrades: [Fact : Double],
         executedRules: [Rule<State, Fact>]) {
        
        self.state = state
        self.assertedFactsAndGrades = assertedFactsAndGrades
        self.executedRules = executedRules
    }

    /// Returns the membership grade of the specified fact.
    ///
    /// If the specified fact is not in the facts array, this method returns 0.0.
    public func grade(for fact: Fact) -> Double {
        return self.assertedFactsAndGrades[fact] ?? 0.0
    }
}

