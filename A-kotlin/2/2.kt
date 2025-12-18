/*
    Didn't manage this one on my own. Got lost in linear algebra shenaningans.
    This solution is based on my friend's suggestion and a post: https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory
 */

data class Machine(
        val buttonWirings: List<Button>,
        val joltageRequirements: JoltageState,
)

data class Button(val wirings: List<Int>)

data class ButtonState(val button: Button, val count: Int)

data class JoltageState(val values: List<Int>)

data class Step(val state: JoltageState, val pressCount: Int)

fun getSingleMatchingButton(index: Int, buttons: List<Button>): Button? {
    val matching = buttons.groupBy { index in it.wirings }[true]

    if (matching == null || matching.size != 1) {
        return null
    }

    return matching[0]
}

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

fun getPressCount(machine: Machine, currentState: JoltageState, cache: HashMap<JoltageState, Int>): Int {
    if (currentState.values.all({ it == 0 })) {
        return 0
    }

    if (currentState.values.any({ it < 0 })) {
        return Int.MAX_VALUE
    }

    if (currentState.values.all { it % 2 == 0 }) {
    return cache.getOrPut(
        currentState,
        {
            safeDouble(
                    getPressCount(machine, JoltageState(currentState.values.map { it / 2 }), cache)
            )
        }
)

    }

    val nextStatesRaw = getNextSteps(machine.buttonWirings, Step(currentState, 0))
    val nextStates =
        nextStatesRaw.filter {
            it.state
                    .values
                    .filterIndexed { index, value ->
                        currentState.values[index] % 2 != 0 && value % 2 != 0
                    }
                    .none()
        }

    val evaluatedStates = nextStates.map {(
        if ( it.state.values.all { it == 0 }) 0
        else cache.getOrPut(it.state, { getPressCount(machine, it.state, cache)})
    ) safeAdd it.pressCount }
    // print("For ")
    // println(currentState)
    // print("Possibilities: ")

    // println(nextStates)

    // print("Evaluated: ")
    // println(evaluatedStates)

    return evaluatedStates.minOrNull() ?: Int.MAX_VALUE
}

fun apply(state: JoltageState, button: Button): JoltageState {
    return apply(state, ButtonState(button, 1))
}

fun apply(state: JoltageState, buttonState: ButtonState): JoltageState {
    return JoltageState(
            state.values.mapIndexed { index, x ->
                if (index in buttonState.button.wirings) x - buttonState.count else x
            }
    )
}

fun getButtonStates(button: Button, state: JoltageState): List<ButtonState> {
    val maxCount = button.wirings.map({ state.values[it] }).min()
    return (0..maxCount).map({ ButtonState(button, maxCount - it) })
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
                        val cache = HashMap<JoltageState, Int>()
                        val pressCount = getPressCount(it, it.joltageRequirements, cache)
                        if (pressCount > 1000) {
                            println()
                            print("EEEEEEEEEEEEEEEEEEEEE: ")
                            println(pressCount)
                        }
                        // println(cache)
                        pressCount
                    })
                    .sum()
    )
}

main()
