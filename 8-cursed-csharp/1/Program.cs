string? line;
string[] position;
long x, y, z, distance;
List<long> positions = [];
List<List<int>> connections = [];
List<ValueTuple<int, int>> connected = [];
int index, secondIndex;
ValueTuple<int, int> closest;

const int SIZE = 3;

READ:
line = Console.ReadLine();
if (string.IsNullOrEmpty(line))
    goto COMPUTE;
position = line.Split(",");
index = 0;
READ_COMPONENT:
positions.Add(long.Parse(position[index]));
index++;
if (index < 3)
    goto READ_COMPONENT;
goto READ;

COMPUTE:
distance = long.MaxValue;
index = 0;
closest = new();//TODO init closest

COMPUTE_NEXT:
secondIndex = index + SIZE;

COMPUTE_SECOND:
if (connected.Contains((index, secondIndex)))
    goto COMPUTE_NEXT_PAIRED;

COMPUTE_NEXT_PAIRED:
secondIndex += SIZE;
if (secondIndex < positions.Count)
    goto COMPUTE_SECOND;
index += SIZE;
if (index < positions.Count - SIZE)
    goto COMPUTE_NEXT;

connected.Add(closest);

if (connected.Count == 1000)
    goto PRINT_RESULT;
goto COMPUTE;


PRINT_RESULT:
Console.WriteLine("");

