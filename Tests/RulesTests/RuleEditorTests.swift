//
//  RuleEditorTests
//  Copyright © 2024 Dan Griffin. All rights reserved.
//

import XCTest
@testable import Rules

final class RuleEditorTests: XCTestCase {

    func testAssertionExample() throws {
        struct State { }
        enum Fact {
            case playerInSight
        }

        let state = State()
        let ruleEditor = RuleEditor<State, Fact>(state: state)

        ruleEditor.assert(.playerInSight, grade: 1.0)
        XCTAssertEqual(ruleEditor.assertedFactsAndGrades[.playerInSight], 1.0)
    }

    func testAssertionOverflowExample() throws {
        struct State { }
        enum Fact {
            case playerInSight
        }

        let state = State()
        let ruleEditor = RuleEditor<State, Fact>(state: state)

        ruleEditor.assert(.playerInSight, grade: 2.0)
        XCTAssertEqual(ruleEditor.assertedFactsAndGrades[.playerInSight], 1.0)
    }

    func testAssertionAdditionOnlyExample() throws {
        struct State { }
        enum Fact {
            case playerInSight
        }

        let state = State()
        let ruleEditor = RuleEditor<State, Fact>(state: state)

        ruleEditor.assert(.playerInSight, grade: 0.3)
        ruleEditor.assert(.playerInSight, grade: 0.3)
        XCTAssertEqual(ruleEditor.assertedFactsAndGrades[.playerInSight], 0.6)
    }

    func testAssertionAdditionOverflowExample() throws {
        struct State { }
        enum Fact {
            case playerInSight
        }

        let state = State()
        let ruleEditor = RuleEditor<State, Fact>(state: state)

        ruleEditor.assert(.playerInSight, grade: 0.5)
        ruleEditor.assert(.playerInSight, grade: 0.7)
        XCTAssertEqual(ruleEditor.assertedFactsAndGrades[.playerInSight], 1.0)
    }

    func testRetractionExample() throws {
        struct State { }
        enum Fact {
            case playerInSight
        }

        let state = State()
        let ruleEditor = RuleEditor<State, Fact>(state: state)

        ruleEditor.assert(.playerInSight, grade: 1.0)
        ruleEditor.retract(.playerInSight, grade: 0.5)

        XCTAssertEqual(ruleEditor.assertedFactsAndGrades[.playerInSight], 0.5)
    }

    func testRetractionRemovalExample() throws {
        struct State { }
        enum Fact {
            case playerInSight
        }

        let state = State()
        let ruleEditor = RuleEditor<State, Fact>(state: state)

        ruleEditor.assert(.playerInSight, grade: 1.0)
        ruleEditor.retract(.playerInSight, grade: 1.0)

        XCTAssertNil(ruleEditor.assertedFactsAndGrades[.playerInSight])
    }

    func testRetractionOverflowRemovalExample() throws {
        struct State { }
        enum Fact {
            case playerInSight
        }

        let state = State()
        let ruleEditor = RuleEditor<State, Fact>(state: state)

        ruleEditor.assert(.playerInSight, grade: 1.0)
        ruleEditor.retract(.playerInSight, grade: 1.0)
        ruleEditor.retract(.playerInSight, grade: 1.0)

        XCTAssertNil(ruleEditor.assertedFactsAndGrades[.playerInSight])
    }

    func testRetractionOverflowRemovalAlternateExample() throws {
        struct State { }
        enum Fact {
            case playerInSight
        }

        let state = State()
        let ruleEditor = RuleEditor<State, Fact>(state: state)

        ruleEditor.assert(.playerInSight, grade: 1.0)
        ruleEditor.retract(.playerInSight, grade: 0.5)
        ruleEditor.retract(.playerInSight, grade: 1.0)

        XCTAssertNil(ruleEditor.assertedFactsAndGrades[.playerInSight])
    }
}
