data class Machine(
    val indicatorLights: List<Boolean>,
    val buttionWirings: List<List<Int>>,
)

fun parseMachine(line: String): Machine {
    val parts = line.split(" ")
    val indicatorLights = parts[0].drop(1).dropLast(1).map({it == '#'})
    val buttonWirings = parts.drop(1).dropLast(1).map({it.drop(1).dropLast(1).split(",").map({Integer.parseInt(it)})})
    return Machine(indicatorLights, buttonWirings)
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
    for (line in getLines().map({ parseMachine(it) })) {
        println(line)
    }
}

main()
