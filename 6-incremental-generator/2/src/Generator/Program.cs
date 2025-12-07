using Microsoft.CodeAnalysis;

namespace Generator;

[Generator]
public class Program : IIncrementalGenerator {
    public void Initialize(IncrementalGeneratorInitializationContext initContext) {
        IncrementalValuesProvider<AdditionalText> textFiles = initContext.AdditionalTextsProvider.Where(static file => file.Path.EndsWith(".txt"));

        IncrementalValuesProvider<(string name, string content)> namesAndContents = textFiles
            .Select(
                (text, cancellationToken) => (
                    name: Path.GetFileNameWithoutExtension(text.Path),
                    content: text.GetText(cancellationToken)!.ToString()
                )
            );

        initContext.RegisterSourceOutput(namesAndContents, (spc, nameAndContent) => {
            spc.AddSource($"Parsed.{nameAndContent.name}", $@"
    public static partial class Parsed
    {{
        public const string {nameAndContent.name} = @""{GetSum()}"";
    }}");

            string GetSum() {
                var lines = nameAndContent.content.Split('\n');
                var operandsLineIndex = GetOperandsLineIndex();
                var operands = lines[operandsLineIndex];
                long sum = 0;
                List<long> numbers = new();
                Func<long> commit = () => 0;
                for (var x = 0; x < operands.Length; x++) {
                    switch (operands[x]) {
                        case '+':
                            CommitAndClear();
                            commit = () => numbers.Sum(); ;
                            break;
                        case '*':
                            CommitAndClear();
                            commit = () => numbers.Aggregate((a, b) => a * b);
                            break;
                    }

                    var anything = false;
                    var value = 0;
                    for (var y = 0; y < operandsLineIndex; y++) {
                        var character = lines[y][x];
                        if (char.IsNumber(character)) {
                            anything = true;
                            value = value * 10 + character - '0';
                        }
                    }
                    if (anything) {
                        numbers.Add(value);
                    }
                }
                CommitAndClear();
                return sum.ToString();

                int GetOperandsLineIndex() {
                    for (var i = 0; i < lines.Length; i++) {
                        var first = lines[i][0];
                        if (char.IsNumber(first) || char.IsWhiteSpace(first)) {
                            continue;
                        }
                        return i;
                    }
                    throw new NotImplementedException();
                }

                void CommitAndClear() {
                    sum += commit();
                    numbers.Clear();
                }
            }
        });
    }
}
