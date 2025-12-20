import std.stdio;
import std.typecons;

alias PresentShape = bool[3][3];

struct Region {
    size_t width, height;
    bool[][] state;
}

PresentShape flipHorizontal(PresentShape shape) {
    PresentShape output = shape;
    output[0][0] = shape[2][0];
    output[0][1] = shape[2][1];
    output[0][2] = shape[2][2];
    return output;
}

PresentShape flipVertical(PresentShape shape) {
    PresentShape output = shape;
    output[0][0] = shape[0][2];
    output[1][0] = shape[1][2];
    output[2][0] = shape[2][2];
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

auto parseInput() {
    PresentShape[] shapes;
    PresentShape instance;
    shapes ~= instance;
    Region[] regions;
    return tuple(shapes, regions);
}

void main() {
    writeln("Parsed: ", parseInput());
}
