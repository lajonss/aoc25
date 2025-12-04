Console.WriteLine(
    Console.In.ReadToEnd()
        .Split('\n')
        .Where(line => !string.IsNullOrWhiteSpace(line))
        .Select(line => line.Select(char.GetNumericValue).Select(n => (byte)n))
        .Select(seq => Joltage(seq, 11))
        .Aggregate((a, b) => a + b)
);

static ulong Joltage(IEnumerable<byte> seq, int numbersLeft, ulong acc = 0) {
    if (numbersLeft < 0) {
        return acc;
    }

    var max = seq.SkipLast(numbersLeft).Index().Max(new Comparer());
    return Joltage(seq.Skip(max.Index + 1), numbersLeft - 1, acc * 10 + max.Item);
}

struct Comparer : IComparer<(int Index, byte Item)> {
    public readonly int Compare((int Index, byte Item) x, (int Index, byte Item) y) {
        if (x.Item > y.Item) {
            return 1;
        } else if (x.Item == y.Item) {
            return 0;
        } else {
            return -1;
        }
    }
}
