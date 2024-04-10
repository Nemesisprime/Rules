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
            return editor.state.distance < 50
        } action: { editor in
            editor.assert(.playerInSight, grade: 1.0)
        }

        let farFromPlayerRule = Rule<State, Fact> { editor in
            return editor.state.distance >= 50
        } action: { editor in
            editor.retract(.playerInSight, grade: 1.0)
        }

        ruleSystem.add(rules: [closeToPlayerRule, farFromPlayerRule])

        let outcome = ruleSystem.evaluate(state: State(distance: 20))
        let grade = outcome.grade(for: .playerInSight)
        XCTAssertEqual(grade, 1.0)

        let outcome2 = ruleSystem.evaluate(state: State(distance: 75))
        let grade2 = outcome2.grade(for: .playerInSight)
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
        let outcome = ruleSystem.evaluate(state: state)
        let grade = outcome.grade(for: .playerNear)
        XCTAssertEqual(grade, 0.5)

        let state2 = State(distance: 35, maxSightDistance: 30)
        let outcome2 = ruleSystem.evaluate(state: state2)
        let grade2 = outcome2.grade(for: .playerNear)
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
