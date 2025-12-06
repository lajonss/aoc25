import haxe.Int64Helper;
import haxe.Int64;

class Class1 {
    static public function main() {
        function readFreshRanges() {
            var output: Array<Range> = [];
            while (true) {
                var line = Sys.stdin().readLine();
                if (line.length > 0) {
                    output.push(new Range(line));
                } else {
                    return output;
                }
            }
        }

        function readAvailable() {
            var output: Array<Int64> = [];
            try {
                while (true) {
                    var line = Sys.stdin().readLine();
                    var number = Int64Helper.parseString(line);
                    if (number == null) {
                        return output;
                    }
                    output.push(number);
                }
            } catch (e:haxe.io.Eof) {
                return output;
            }
        }

        var freshRanges = readFreshRanges();
        var available = readAvailable();
        var count = 0;
        for (element in available) {
            for (range in freshRanges) {
                if (element >= range.start && element <= range.end) {
                    count++;
                    break;
                }
            }
        }
        Sys.println(count);
    }

}

class Range {
    public final start:Int64;
    public final end:Int64;

    public function new(line:String) {
        var parts = line.split("-");
        this.start = Int64Helper.parseString(parts[0]);
        this.end = Int64Helper.parseString(parts[1]);
    }
}