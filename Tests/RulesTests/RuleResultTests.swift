//
//  RuleResultTests
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import XCTest
@testable import Rules

final class RuleResultTests: XCTestCase {

    func testGrade() throws {
        struct State { }
        enum Fact {
            case playerInSight
            case chargeLevel
        }
        
        let result = RuleResult<State, Fact>(state: State(),
                                             assertedFactsAndGrades: [
                                                .playerInSight: 1.0,
                                                .chargeLevel: 0.5
                                             ],
                                             executedRules: [])

        XCTAssertEqual(result.grade(for: .playerInSight), 1.0)
        XCTAssertEqual(result.grade(for: .chargeLevel), 0.5)
    }

    func testGradeMinimum() throws {
        struct State { }
        enum Fact {
            case playerInSight
            case chargeLevel
            case fleeAbility
        }

        let result = RuleResult<State, Fact>(state: State(),
                                             assertedFactsAndGrades: [
                                                .playerInSight: 1.0,
                                                .chargeLevel: 0.5
                                             ],
                                             executedRules: [])

        XCTAssertEqual(result.minimumGrade(forFacts: [
            .playerInSight, .chargeLevel
        ]), 0.5)
    }

    func testGradeImpliedZero() throws {
        struct State { }
        enum Fact {
            case playerInSight
            case chargeLevel
            case fleeAbility
        }

        let result = RuleResult<State, Fact>(state: State(),
                                             assertedFactsAndGrades: [
                                                .playerInSight: 1.0,
                                                .chargeLevel: 0.5
                                             ],
                                             executedRules: [])

        XCTAssertEqual(result.minimumGrade(forFacts: [
            .playerInSight, .chargeLevel, .fleeAbility
        ]), 0.0)
    }

    func testGradeMaximum() throws {
        struct State { }
        enum Fact {
            case playerInSight
            case chargeLevel
            case fleeAbility
        }

        let result = RuleResult<State, Fact>(state: State(),
                                             assertedFactsAndGrades: [
                                                .playerInSight: 1.0,
                                                .chargeLevel: 0.5
                                             ],
                                             executedRules: [])

        XCTAssertEqual(result.maximumGrade(forFacts: [
            .playerInSight,
            .chargeLevel,
            .fleeAbility
        ]), 1.0)
    }

    func testGradeMaximumImpliedZero() throws {
        struct State { }
        enum Fact {
            case playerInSight
            case chargeLevel
            case fleeAbility
        }

        let result = RuleResult<State, Fact>(state: State(),
                                             assertedFactsAndGrades: [
                                                .playerInSight: 1.0,
                                                .chargeLevel: 0.5
                                             ],
                                             executedRules: [])

        XCTAssertEqual(result.maximumGrade(forFacts: [
            .fleeAbility
        ]), 0.0)
    }


}
