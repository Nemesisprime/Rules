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

A more complicated system might work to blend values for more unique and emergent results:

```swift
struct State {
    var distance: Double
    var maxSightDistance: Double

    var charge: Double
    var fullCharge: Double
}

enum Fact {
    case playerNear
    case laserChargePower
    case shouldFire
}

let ruleSystem = RuleSystem<State, Fact>()

let closeToPlayerRule = Rule<State, Fact> { editor in
    return editor.state.distance <= 50
} action: { editor in
    // The closer, the higher the value
    let isNearValue = Double(1.0 - editor.state.distance / editor.state.maxSightDistance)
    editor.assert(.playerNear, grade: isNearValue)
}

let chargeLevel = Rule<State, Fact> { editor in
    return true
} action: { editor in
    // The more full, the higher
    let isAlmostCharged = editor.state.charge / editor.state.fullCharge
    editor.assert(.laserChargePower, grade: isAlmostCharged)
}

let shouldFireRule = Rule<State, Fact>(salience: 1) { editor in
    return true
} action: { editor in
    let partialResult = editor.makeResult()
    // Note that minimum Grade is a logical AND in our fuzzy world, so we are asking:
    // shouldFire = .playerNear AND .laserChargePower
    let shouldFire = partialResult.minimumGrade(for: [
        .playerNear,
        .laserChargePower
    ])
    editor.assert(.shouldFire, grade: shouldFire)
}

ruleSystem.add(rules: [closeToPlayerRule, chargeLevel, shouldFireRule])

let state = State(
    distance: 15,
    maxSightDistance: 30,
    charge: 60,
    fullCharge: 100
)
let result = ruleSystem.evaluate(state: state)
let grade = result.grade(for: .shouldFire)
```
