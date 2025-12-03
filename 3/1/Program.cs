Console.WriteLine(
    Console.In.ReadToEnd()
        .Split('\n')
        .Where(line => !string.IsNullOrWhiteSpace(line))
        .Select(line => line.Select(char.GetNumericValue).Select(n => (uint)n))
        .Select(seq => seq.SkipLast(1).Index().SelectMany(first => seq.Skip(first.Index + 1).Select(second => first.Item * 10 + second)).Max())
        .Aggregate((a, b) => a + b)
);