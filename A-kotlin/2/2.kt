data class Machine(
        val buttonWirings: List<Button>,
        val joltageRequirements: JoltageState,
)

data class Button(val wirings: List<Int>)

data class ButtonState(val button: Button, val count: Int)

data class JoltageState(val values: List<Int>)

fun getSingleMatchingButton(index: Int, buttons: List<Button>): Button? {
    val matching = buttons.groupBy { index in it.wirings }[true]

    if (matching == null || matching.size != 1) {
        return null
    }

    return matching[0]
}

fun getPressCount(buttons: List<Button>, currentState: JoltageState, pressCount: Int): Int? {
    if (currentState.values.all({ it == 0 })) {
        return pressCount
    }

    if (currentState.values.any({ it < 0 })) {
        return null
    }

    val nextButton = buttons.firstOrNull()
    if (nextButton == null) {
        return null
    }

    for (index in (0 ..< currentState.values.size).filter { currentState.values[it] != 0 }) {
        val singleMatching = getSingleMatchingButton(index, buttons)
        if (singleMatching != null) {
            val count = currentState.values[index]
            val buttonState = ButtonState(singleMatching, count)
            return getPressCount(
                    buttons.filter { it != singleMatching },
                    apply(currentState, buttonState),
                    pressCount + count
            )
        }
    }

    val rest = buttons.drop(1)
    for (buttonState in getButtonStates(nextButton, currentState)) {
        val nextPressCount =
                getPressCount(
                        rest,
                        apply(currentState, buttonState),
                        pressCount + buttonState.count
                )
        if (nextPressCount != null) {
            return nextPressCount
        }
    }

    return null
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
                        val pressCount = getPressCount(it.buttonWirings, it.joltageRequirements, 0)
                        if (pressCount == null) throw NullPointerException() else pressCount
                    })
                    .sum()
    )
}

main()
