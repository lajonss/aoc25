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
    bool[][] state;
}

PresentShape flip(PresentShape shape)
{
    PresentShape output;
    foreach (y; 0 .. 3)
    {
        foreach (x; 0 .. 3)
        {
            output[y][x] = shape[y][2 - x];
        }
    }
    return output;
}

PresentShape rotate(PresentShape shape) {
    PresentShape output;
    output[0][0] = shape[2][0];
    output[0][1] = shape[1][0];
    output[0][2] = shape[0][0];
    output[1][0] = shape[2][1];
    output[1][1] = shape[1][1];
    output[1][2] = shape[0][1];
    output[2][0] = shape[2][2];
    output[2][1] = shape[1][2];
    output[2][2] = shape[0][2];
    return output;
}

InputRange!PresentShape getAllVariations(PresentShape original)
{
    return new Generator!PresentShape({
        yield(original);
        yield(flip(original));
        auto r90 = rotate(original);
        yield(r90);
        yield(flip(r90));
        auto r180 = rotate(r90);
        yield(r180);
        yield(flip(r180));
        auto r270 = rotate(r180);
        yield(r270);
        yield(flip(r270));
    });
}

char formatCell(bool value)
{
    return value ? '#' : '.';
}

void writePresent(PresentShape present)
{
    foreach (y; 0 .. 3)
    {
        writeln("", formatCell(present[y][0]), formatCell(present[y][1]), formatCell(present[y][2]));
    }
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
        region.state.length = region.height;
        for (size_t i = 0; i < region.height; i++)
        {
            region.state[i].length = region.width;
        }
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

struct Pivot
{
    size_t x, y;
}

InputRange!Pivot getAllPivots(Region region)
{
    return new Generator!Pivot({
        foreach (y; 0 .. region.height - 2)
        {
            foreach (x; 0 .. region.width - 2)
            {
                yield(Pivot(x, y));
            }
        }
    });
}

bool tryToApply(Pivot pivot, PresentShape presentShape, Region region)
{
    foreach (y; 0 .. 3)
    {
        foreach (x; 0 .. 3)
        {
            if (presentShape[y][x] && region.state[pivot.y + y][pivot.x + x])
            {
                return false;
            }
        }
    }

    foreach (y; 0 .. 3)
    {
        foreach (x; 0 .. 3)
        {
            if (presentShape[y][x])
            {
                region.state[pivot.y + y][pivot.x + x] = true;
            }
        }
    }
    return true;
}

void revert(Pivot pivot, PresentShape presentShape, Region region)
{
    foreach (y; 0 .. 3)
    {
        foreach (x; 0 .. 3)
        {
            if (presentShape[y][x])
            {
                region.state[pivot.y + y][pivot.x + x] = false;
            }
        }
    }
}

struct PresentRequirement
{
    PresentShape presentShape;
    size_t count;
}

bool canSatisfy(Region region, PresentRequirement[] requirements)
{
    if (requirements.length == 0)
    {
        return true;
    }

    auto requirement = requirements[0];
    if (requirement.count == 0)
    {
        return canSatisfy(region, requirements[1 .. requirements.length]);
    }

    foreach (shape; getAllVariations(requirements[0].presentShape))
    {
        foreach (pivot; getAllPivots(region))
        {
            if (tryToApply(pivot, shape, region))
            {
                requirements[0].count--;
                auto nextRequirements = requirements[0].count == 0 ? requirements[1 .. requirements
                    .length] : requirements;

                if (canSatisfy(region, nextRequirements))
                {
                    return true;
                }

                requirements[0].count++;
                revert(pivot, shape, region);
            }
        }
    }

    return false;
}

bool canSatisfy(Region region, PresentShape[] presentShapes)
{
    if (region.width * region.height / 9 >= region.requirements.sum())
    {
        return true;
    }

    PresentRequirement[] requirements;
    for (size_t i = 0; i < presentShapes.length; i++)
    {
        requirements ~= PresentRequirement(presentShapes[i], region.requirements[i]);
    }
    return canSatisfy(region, requirements);
}

void main() {
    auto parsed = parseInput();
    auto presentShapes = parsed[0];
    auto regions = parsed[1];
    write(regions.count!(region => canSatisfy(region, presentShapes)), '\n');
}
