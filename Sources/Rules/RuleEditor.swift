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

    public func makeResult(executedRules: [Rule<State, Fact>] = []) -> RuleResult<State, Fact> {
        return RuleResult(state: self.state,
                          assertedFactsAndGrades: self.assertedFactsAndGrades,
                          executedRules: executedRules)
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
