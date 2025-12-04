const int DIGITS = 12;

Console.WriteLine(
    Console.In.ReadToEnd()
        .Split('\n')
        .Where(line => !string.IsNullOrWhiteSpace(line))
        .Select(line => line.Select(char.GetNumericValue).Select(n => (byte)n))
        .Select(seq => Enumerable.Range(0, DIGITS)
            .Select(x => DIGITS - 1 - x)
            .Aggregate((seq, 0UL), (acc, numbersLeft) => {
                var max = acc.seq.SkipLast(numbersLeft).Index().Max(new Comparer());
                return (acc.seq.Skip(max.Index + 1), acc.Item2 * 10 + max.Item);
            })
            .Item2
        )
        .Aggregate((a, b) => a + b)
);

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
