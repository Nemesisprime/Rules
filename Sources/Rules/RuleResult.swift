//
//  RuleResult
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

public struct RuleResult<State, Fact: Hashable> {

    /// An immutable copy of the state associated with the evaluated rule result
    public let state: State

    /// A raw copy of the facts and grades generated from the evaluation
    private let assertedFactsAndGrades: [Fact: Double]

    /// The list of facts claimed by the rule system
    public var facts: [Fact] {
        return assertedFactsAndGrades.keys.map { $0 }
    }

    public let executedRules: [Rule<State, Fact>]

    internal init(state: State,
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

    /// Returns the lowest membership grade among the specified facts.
    ///
    /// In fuzzy logic, this method is called the AND Zadeh operator, because it
    /// corresponds to the AND operator in Boolean logic.
    ///
    /// If a fact is not in the facts array, its membership grade for purposes of this
    /// operation is implicitly zero.
    public func minimumGrade(forFacts facts: [Fact]) -> Double {
        return facts.map {
            return self.assertedFactsAndGrades[$0] ?? 0.0
        }.min() ?? 0.0
    }

    /// Returns the highest membership grade among the specified facts.
    ///
    /// In fuzzy logic, this method is called the OR Zadeh operator, because it
    /// corresponds to the OR operator in Boolean logic.
    ///
    /// If a fact is not in the facts array, its membership grade for purposes of this
    /// operation is implicitly zero.
    public func maximumGrade(forFacts facts: [Fact]) -> Double {
        return facts.map {
            return self.assertedFactsAndGrades[$0] ?? 0.0
        }.max() ?? 0.0
    }
}

