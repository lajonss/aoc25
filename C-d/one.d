import std.algorithm;
import std.array;
import std.concurrency;
import std.conv;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

alias PresentShape = bool[3][3];

struct Region {
    size_t width, height;
    size_t[] requirements;
}

auto parseInput() {
    PresentShape[] shapes;
    string line;
    size_t xIndex;
    while (true)
    {
        line = stdin.readln();
        xIndex = indexOf(line, 'x');
        if (xIndex != -1)
        {
            break;
        }
        PresentShape shape;
        foreach (y; 0 .. 3)
        {
            line = stdin.readln();
            foreach (x; 0 .. 3)
            {
                shape[y][x] = line[x] == '#';
            }
        }
        shapes ~= shape;
        stdin.readln();
    }

    Region[] regions;
    do
    {
        Region region;
        region.width = to!size_t(line[0 .. xIndex]);
        auto colonIndex = indexOf(line, ':');
        region.height = to!size_t(line[xIndex + 1 .. colonIndex]);
        region.requirements = line[colonIndex + 1 .. line.length].split(" ")
            .filter!(x => x.length > 0)
            .map!(x => parse!size_t(x))
            .array();
        regions ~= region;

        line = stdin.readln();
        xIndex = indexOf(line, 'x');
    }
    while (line.length > 0);

    return tuple(shapes, regions);
}

void main() {
    auto parsed = parseInput();
    auto regions = parsed[1];
    write(regions.count!(region => region.width * region.height / 9 >= region.requirements.sum()), '\n');
}
