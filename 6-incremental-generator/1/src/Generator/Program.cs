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
                List<long[]> rows = new();
                long sum = 0;
                foreach (var line in nameAndContent.content.Split('\n')) {
                    var tokens = line.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    if (long.TryParse(tokens[0], out _)) {
                        rows.Add(tokens.Select(long.Parse).ToArray());
                    } else {
                        for (var i = 0; i < tokens.Length; i++) {
                            var operands = rows.Select(r => r[i]);
                            sum += tokens[i] switch {
                                "+" => operands.Sum(),
                                "*" => operands.Aggregate((a, b) => a * b),
                                _ => throw new NotImplementedException(tokens[i])
                            };
                        }
                        return sum.ToString();
                    }
                }
                throw new NotImplementedException();
            }
        });
    }
}
