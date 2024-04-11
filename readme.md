#  Rules

A simple fuzzy logic engine that mirrors GKRule and GKRuleSystem, but written in Swift, typed, and produces a less ambiguous state by introducing additional objects.

This replicates the majority of the rule/rule system introduced in GameplayKit, but omits the plist and serialization archiving because that's something I don't plan on using.

## Simple Examples

```swift
// 1
struct State {
    var distance: Int
}

enum Fact {
    case playerInSight
}

// 2
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

// 3
let ruleSystem = RuleSystem<State, Fact>()
ruleSystem.add(rules: [closeToPlayerRule, farFromPlayerRule])

// 4
let state = State(distance: 20)
let result = ruleSystem.evaluate(state: state)

// 5
let grade = result.grade(for: .playerInSight)
```

1. Define your State and Facts.
    - State is what your rules use to determine Facts
    - Facts are the output of the evaluation of the rules
2. Define your rules using Rule.
3. Create your rule system and add your rules. Only rules that understand the system's State and Facts are accepted into a system.
4. Generate a state and provide it to the evaluation function to get a `RuleResult`
5. Interpret results by using `grade`/`minimumGrade`/`maximumGrade` on the results.
