import haxe.Int64Helper;
import haxe.Int64;

class Class2 {
    static public function main() {
		function readFreshRanges():Array<Range> {
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

		function rangeCompare(x:Range, y:Range) {
			if (x.start > y.start) {
				return 1;
			} else if (x.start == y.start) {
				return 0;
			} else {
				return -1;
            }
        }

        var freshRanges = readFreshRanges();
		freshRanges.sort(rangeCompare);
		var count = Int64.ofInt(0);
		var previous:Null<Int64> = null;
		for (range in freshRanges) {
			if (previous == null) {
				count += range.end - range.start + 1;
			} else if (range.end < previous) {
				continue;
			} else if (range.start <= previous) {
				count += range.end - previous;
			} else {
				count += range.end - range.start + 1;
			}
			previous = range.end;
		}
		Sys.println(Int64.toStr(count));
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