//
//  RuleEditor
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import Foundation

class RuleEditor<State, Fact: Hashable> {
    var state: State

    public private(set) var assertedFactsAndGrades = [Fact: Double]()

    init(state: State) {
        self.state = state
    }

    public func makeResult() -> RuleResult<State, Fact> {
        return RuleResult(state: self.state, 
                          assertedFactsAndGrades: self.assertedFactsAndGrades)
    }

    private static func clamp(_ grade: Double) -> Double {
        return max(0, min(1.0, grade))
    }

    public func assert(_ fact: Fact, grade: Double = 1.0) {
        if let currentFactGrade = assertedFactsAndGrades[fact] {
            let updatedFactGrade = Self.clamp(currentFactGrade + grade)
            self.assertedFactsAndGrades[fact] = updatedFactGrade
        } else {
            self.assertedFactsAndGrades[fact] = Self.clamp(grade)
        }
    }

    public func retract(_ fact: Fact, grade: Double = 1.0) {
        // We only can retract facts that are currently established
        guard let currentFactGrade = assertedFactsAndGrades[fact] else {
            return
        }

        let updatedFactGrade = currentFactGrade - grade
        if updatedFactGrade > 0.0 {
            assertedFactsAndGrades[fact] = updatedFactGrade
        } else {
            assertedFactsAndGrades.removeValue(forKey: fact)
        }
    }
}

class RuleResult<State, Fact: Hashable> {

    /// An immutable copy of the state associated with the evaluated rule result
    let state: State

    /// A raw copy of the facts and grades generated from the evaluation
    private var assertedFactsAndGrades = [Fact: Double]()

    /// The list of facts claimed by the rule system
    var facts: [Fact] {
        return assertedFactsAndGrades.keys.map { $0 }
    }

    /// Public Initializer
    init(state: State, assertedFactsAndGrades: [Fact: Double]) {
        self.state = state
    }

    /// Returns the membership grade of the specified fact.
    ///
    /// If the specified fact is not in the facts array, this method returns 0.0.
    public func grade(for fact: Fact) -> Double {
        return self.assertedFactsAndGrades[fact] ?? 0.0
    }
}

