import XCTest
@testable import Rules



final class RulesTests: XCTestCase {
    func testSimpleExample() throws {
        struct State {
            var distance: Int
        }

        enum Fact {
            case playerClose
        }


        let ruleSystem = RuleSystem<State, Fact>()

        let closeToPlayerRule = Rule<State, Fact> { editor in
            return editor.state.distance < 50
        } action: { editor in
            editor.assert(.playerClose, grade: 1.0)
        }

        let farFromPlayerRule = Rule<State, Fact> { editor in
            return editor.state.distance >= 50
        } action: { editor in
            editor.retract(.playerClose, grade: 1.0)
        }

        let outcome = ruleSystem.evaluate(state: State(distance: 20))
        let grade = outcome.grade(for: .playerClose)
        XCTAssertEqual(grade, 1.0)
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
