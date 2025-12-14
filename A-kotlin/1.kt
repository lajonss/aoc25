data class Machine(
    val indicatorLights: Long,
    val indicatorLightsSize: Long,
    val buttonWirings: List<Long>,
)

fun parseMachine(line: String): Machine {
    val parts = line.split(" ")
    val indicatorLightsSpec = parts[0].drop(1).dropLast(1)
    val indicatorLights = indicatorLightsSpec.map({it == '#'}).foldRight(0L, { current, acc -> (acc shl 1) + if (current) 1 else 0})
    val indicatorLightsSize = 1L shl indicatorLightsSpec.count()
    val buttonWirings = parts.drop(1).dropLast(1).map({it.drop(1).dropLast(1).split(",").map({Integer.parseInt(it)}).fold(0L, {acc, current -> acc + (1 shl current)})})
    return Machine(indicatorLights, indicatorLightsSize, buttonWirings)
}

fun getState(machine: Machine, pressedCount: Int): Sequence<Long> {
    if (pressedCount == 0) {
        return sequenceOf(0L)
    }
    return getState(machine, pressedCount -1).flatMap({outer -> machine.buttonWirings.map({(outer xor it) % machine.indicatorLightsSize})})
}

fun getPressCount(machine: Machine): Int {
    for(pressedCount in 1..Int.MAX_VALUE) {
        for(possibleState in getState(machine, pressedCount)) {
            if (possibleState == machine.indicatorLights) {
                return pressedCount
            }
        }
    }
    throw Exception()
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
    println(getLines().map(::parseMachine).map(::getPressCount).sum())
}

main()
