/*
    Didn't manage this one on my own. Got lost in linear algebra shenaningans.
    This solution is based on my friend's suggestion and a post: https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory
 */

data class Machine(
        val buttonWirings: List<Button>,
        val joltageRequirements: JoltageState,
)

data class Button(val wirings: List<Int>)

data class JoltageState(val values: List<Int>)

data class Step(val state: JoltageState, val pressCount: Int)

fun safeDouble(value: Int): Int {
    if (value == Int.MAX_VALUE) {
        return Int.MAX_VALUE
    }
    return value * 2
}

infix fun Int.safeAdd(other: Int): Int {
    if (this == Int.MAX_VALUE || other == Int.MAX_VALUE) {
        return Int.MAX_VALUE
    }
    return this + other
}

fun getNextSteps(buttons: List<Button>, step: Step): List<Step> {
    if (buttons.size == 0) {
        return if (step.pressCount == 0) emptyList() else listOf(step)
    }

    val enabledState = apply(step.state, buttons.first())
    val rest = buttons.drop(1)

    if (enabledState.values.any { it < 0 }) {
        return getNextSteps(rest, step)
    }

    return getNextSteps(rest, Step(enabledState, step.pressCount + 1)) + getNextSteps(rest, step)
}

fun getPressCount(machine: Machine, currentState: JoltageState, cache: HashMap<JoltageState, Int>, doubleCheck: Boolean): Int {
    print("Evaluating: ")
    print(currentState)
    // print(" with cache of ")
    // println(cache.size)

    if (currentState.values.all({ it == 0 })) {
        return 0
    }

    if (currentState.values.any({ it < 0 })) {
        return Int.MAX_VALUE
    }

    if (currentState.values.all { it % 2 == 0 }) {
        val doubled = safeDouble(
            getPressCountCached(machine, JoltageState(currentState.values.map { it / 2 }), cache, doubleCheck)
        )
        if (!doubleCheck || doubled != Int.MAX_VALUE) {
            return doubled
        }
    }

    val nextStatesRaw = getNextSteps(machine.buttonWirings, Step(currentState, 0))
    val nextStates = nextStatesRaw.filter { it.state.values.all { it % 2 == 0 } }

    val evaluatedStates = nextStates.map {(
        if ( it.state.values.all { it == 0 }) 0
        else getPressCountCached(machine, it.state, cache, doubleCheck)
    ) safeAdd it.pressCount }
    print("For ")
    println(currentState)
    // print("Raw: ")
    // println(nextStatesRaw)
    print("Possibilities: ")
    println(nextStates)
    print("Evaluated: ")
    println(evaluatedStates)

    return evaluatedStates.minOrNull() ?: Int.MAX_VALUE
}

fun getPressCountCached(machine: Machine, currentState: JoltageState, cache: HashMap<JoltageState, Int>, doubleCheck: Boolean): Int {
    return cache.getOrPut(currentState, {
        getPressCount(machine, currentState, cache, doubleCheck)
    })
}

fun apply(state: JoltageState, button: Button): JoltageState {
    return JoltageState(
        state.values.mapIndexed { index, value -> if (index in button.wirings) value - 1 else value }
    )
}

fun parseMachine(line: String): Machine {
    println(line)
    val parts = line.split(" ")
    val buttonWirings =
            parts.drop(1)
                    .dropLast(1)
                    .map({ it.drop(1).dropLast(1).split(",").map({ Integer.parseInt(it) }) })
                    .sortedByDescending { it.size }
                    .map { Button(it) }
    val joltageRequirements =
            parts.last().drop(1).dropLast(1).split(",").map({ Integer.parseInt(it) })
    val machine = Machine(buttonWirings, JoltageState(joltageRequirements))
    // println(machine)
    return machine
}

fun getLine(): String? {
    val line = readlnOrNull()
    if (line == null || line.length == 0) {
        return null
    }
    return line
}

fun getLines(): Sequence<String> {
    return generateSequence() { getLine() }
}

fun main() {
    println(
        getLines()
            .map(::parseMachine)
            .map({
                var pressCount = getPressCountCached(it, it.joltageRequirements, HashMap<JoltageState, Int>(), false)
                if (pressCount == Int.MAX_VALUE) {
                    pressCount = getPressCountCached(it, it.joltageRequirements, HashMap<JoltageState, Int>(), true)
                }
                println(pressCount)
                pressCount
            })
            .sum()
    )
}

main()
