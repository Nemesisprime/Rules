import XCTest
@testable import Rules

final class RulesTests: XCTestCase {
    func testSimpleBooleanExample() throws {
        struct State {
            var distance: Int
        }

        enum Fact {
            case playerInSight
        }


        let ruleSystem = RuleSystem<State, Fact>()

        let closeToPlayerRule = Rule<State, Fact> { editor in
            return editor.state.distance <= 50
        } action: { editor in
            editor.assert(.playerInSight, grade: 1.0)
        }

        let farFromPlayerRule = Rule<State, Fact> { editor in
            return editor.state.distance > 50
        } action: { editor in
            editor.retract(.playerInSight, grade: 1.0)
        }

        ruleSystem.add(rules: [closeToPlayerRule, farFromPlayerRule])

        let result = ruleSystem.evaluate(state: State(distance: 20))
        let grade = result.grade(for: .playerInSight)
        XCTAssertEqual(grade, 1.0)

        let result2 = ruleSystem.evaluate(state: State(distance: 75))
        let grade2 = result2.grade(for: .playerInSight)
        XCTAssertEqual(grade2, 0)
    }

    func testSimpleFuzzyExample() throws {
        struct State {
            var distance: Double
            var maxSightDistance: Double
        }

        enum Fact {
            case playerNear
        }

        let ruleSystem = RuleSystem<State, Fact>()

        let closeToPlayerRule = Rule<State, Fact> { editor in
            return editor.state.distance <= 30
        } action: { editor in
            // The closer, the higher the value
            let isNearValue = Double(1.0 - editor.state.distance / editor.state.maxSightDistance)
            editor.assert(.playerNear, grade: isNearValue)
        }

        ruleSystem.add(rule: closeToPlayerRule)

        let state = State(distance: 15, maxSightDistance: 30)
        let result = ruleSystem.evaluate(state: state)
        let grade = result.grade(for: .playerNear)
        XCTAssertEqual(grade, 0.5)

        let state2 = State(distance: 35, maxSightDistance: 30)
        let result2 = ruleSystem.evaluate(state: state2)
        let grade2 = result2.grade(for: .playerNear)
        XCTAssertEqual(grade2, 0)
    }

    func testSalienceOrderExample() throws {
        struct State { }

        enum Fact {
            case didRun
        }


        let ruleSystem = RuleSystem<State, Fact>()

        // Runs before the other, even though its second in the array
        let firstRule = Rule<State, Fact>(salience: 0) { editor in
            return true
        } action: { editor in
            editor.retract(.didRun, grade: 1.0)
        }

        // Runs second, despite being first in the array.
        let secondRule = Rule<State, Fact>(salience: 1) { editor in
            return true
        } action: { editor in
            editor.assert(.didRun, grade: 1.0)
        }

        ruleSystem.add(rules: [secondRule, firstRule])

        let result2 = ruleSystem.evaluate(state: State())
        let grade2 = result2.grade(for: .didRun)
        XCTAssertEqual(grade2, 1.0)
    }

    func testReevaluatesRulesetExample() throws {
        struct State { }

        enum Fact {
            case didRun
        }


        let ruleSystem = RuleSystem<State, Fact>()

        // Skipped until the second rule has been run
        let firstRule = Rule<State, Fact>(salience: 0) { editor in
            // Only run if we have an asserted fact.
            // We then retract that fact
            return editor.assertedFactsAndGrades.keys.contains(.didRun)
        } action: { editor in
            editor.retract(.didRun, grade: 1.0)
        }

        // After this runs, the evaluation is clear to run the first rule.
        let secondRule = Rule<State, Fact>(salience: 1) { editor in
            return true
        } action: { editor in
            editor.assert(.didRun, grade: 1.0)
        }

        ruleSystem.add(rules: [firstRule, secondRule])

        let result2 = ruleSystem.evaluate(state: State())
        let grade2 = result2.grade(for: .didRun)
        XCTAssertEqual(grade2, 0)
    }


//    func testTertiaryExample() throws {
//        struct State {
//            var health: Int
//        }
//
//        enum Fact {
//            case criticalCondition
//            case hurt
//            case healthy
//        }
//
//
//        let ruleSystem = RuleSystem<State, Fact>()
//
//        let rule = Rule<State, Fact>(
////            fact: .criticalCondition
//        )
////        let rule1 = Rule<State, Fact>(
//////            fact: .hurt
////        )
////        let rule2 = Rule<State, Fact>(
//////            fact: .healthy
////        )
//
//        let outcome = ruleSystem.evaluate(state: State(health: 50))
//
//        let criticalGrade = outcome.grade(for: .criticalCondition)
//        let hurtGrade = outcome.grade(for: .hurt)
//        let healthyGrade = outcome.grade(for: .healthy)
//    }
}
