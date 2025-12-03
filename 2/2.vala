using Math;

const long DEFAULT = -1;

struct Multiple {
    public long value;
    public long multiplier;
}

Multiple get_smallest_multiple_larger_or_equal_to(long number, long divider) {
    if (number % divider == 0) {
        return Multiple() {
            value = number,
            multiplier = number / divider
        };
    }
    var multiplier = number / divider + 1;
    return Multiple() {
        value = multiplier * divider,
        multiplier = multiplier
    };
}

Multiple get_largest_multiple_smaller_or_equal_to(long number, long divider) {
    var multiplier = number/divider;
    return Multiple() {
        value = multiplier * divider,
        multiplier = multiplier
    };
}

long get_divider(long magnitude, long step) {
    if ((magnitude + 1) % step != 0) {
        return 0L;
    }

    var divider = 0L;
    var current = 0L;
    while (current <= magnitude) {
        divider += (long)pow(10, current);
        current += step;
    }
    stdout.printf("divider: %ld\n", divider);
    return divider;
}

long get_magnitude_start(long magnitude) {
    return (long)pow(10, magnitude);
}

long get_magnitude_end(long magnitude) {
    return (long)pow(10, magnitude + 1) - 1;
}

long sum_invalid_ids_of_same_magnitude(long magnitude, long start = DEFAULT, long end = DEFAULT) {
    if (start == DEFAULT) {
        start = get_magnitude_start(magnitude);
    }

    if (end == DEFAULT) {
        end = get_magnitude_end(magnitude);
    }

    var step = 0L;
    var sum = 0L;
    while(step < (magnitude + 1) / 2) {
        step += 1;
        var divider = get_divider(magnitude, step);
        if (divider == 0) {
            continue;
        }

        var first = get_smallest_multiple_larger_or_equal_to(start, divider);
        if (first.value > end) {
            continue;
        }

        var last = get_largest_multiple_smaller_or_equal_to(end, divider);
        var count = last.multiplier - first.multiplier + 1L;
        var current = (first.multiplier + last.multiplier) * count * divider / 2L;
        stdout.printf("%ld-%ld %ld\n", start, end, current);
        sum += current;
    }

    return sum;
}

long sum_invalid_ids(long start, long end) {
    var start_magnitude = (long)log10(start);
    var end_magnitude = (long)log10(end);
    if (start_magnitude == end_magnitude) {
        return sum_invalid_ids_of_same_magnitude(start_magnitude, start, end);
    }

    var sum = 0L;
    sum += sum_invalid_ids_of_same_magnitude(start_magnitude, start);
    for (var i = start_magnitude + 1; i < end_magnitude; i++) {
        sum += sum_invalid_ids_of_same_magnitude(i);
    }
    sum += sum_invalid_ids_of_same_magnitude(end_magnitude, DEFAULT, end);
    return sum;
}

void main() {
    var input = stdin.read_line();
    var sum = 0L;
    foreach (var range in input.split(",")) {
        var numbers = range.split("-");
        var start = long.parse(numbers[0]);
        var end = long.parse(numbers[1]);
        var in_range = sum_invalid_ids(start, end);
        //  stdout.printf("%ld-%ld: %ld\n", start, end, in_range);
        sum += in_range;
    }
    stdout.printf("%ld\n", sum);
}