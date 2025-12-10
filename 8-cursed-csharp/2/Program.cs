string? line;
string[] position;
int index, secondIndex, setID, secondSetID, distanceIndex, setBuffer;
List<long> positions = [];
List<(int a, int b, float distance)> distances = [];
(int a, int b, float distance) distanceData;
int[] sets;
long acc;
float distance;
bool flag;

const int SIZE = 3;


READ:
line = Console.ReadLine();
if (string.IsNullOrEmpty(line))
    goto COMPUTE_DISTANCES;
position = line.Split(",");
index = 0;
READ_COMPONENT:
positions.Add(long.Parse(position[index]));
index++;
if (index < SIZE)
    goto READ_COMPONENT;
goto READ;


COMPUTE_DISTANCES:
index = 0;

COMPUTE_DISTANCES_NEXT:
secondIndex = index + SIZE;

COMPUTE_DISTANCES_NEXT_SECOND:
acc = positions[index];
acc -= positions[secondIndex];
acc *= acc;
distance = acc;

acc = positions[index + 1];
acc -= positions[secondIndex + 1];
acc *= acc;
distance += acc;

acc = positions[index + 2];
acc -= positions[secondIndex + 2];
acc *= acc;
distance += acc;
distance = MathF.Sqrt(distance);

distanceData.a = index / SIZE;
distanceData.b = secondIndex / SIZE;
distanceData.distance = distance;
distances.Add(distanceData);

secondIndex += SIZE;
if (secondIndex < positions.Count)
    goto COMPUTE_DISTANCES_NEXT_SECOND;

index += SIZE;
if (index < positions.Count - SIZE)
    goto COMPUTE_DISTANCES_NEXT;

distances.Sort(new Comparer());

index = 0;
sets = new int[positions.Count / SIZE];

INIT_SETS:
sets[index] = index;
index++;
if (index < sets.Length)
    goto INIT_SETS;

distanceIndex = 0;

CHECK_CONNECTION:
distanceData = distances[distanceIndex];
setID = sets[distanceData.a];
secondSetID = sets[distanceData.b];
if (setID == secondSetID)
    goto CHECK_NEXT_CONNECTION;

flag = false;
index = 0;

CHECK_NEXT_SET:
setBuffer = sets[index];
if (setBuffer == secondSetID)
    goto REPLACE_SET;
if (setBuffer == setID)
    goto NEXT_INDEX;

flag = true;
goto NEXT_INDEX;

REPLACE_SET:
sets[index] = setID;

NEXT_INDEX:
index++;
if (index < sets.Length)
    goto CHECK_NEXT_SET;

if (!flag)
    goto COMPUTE_RESULT;

CHECK_NEXT_CONNECTION:
distanceIndex++;
goto CHECK_CONNECTION;

COMPUTE_RESULT:
index = distanceData.a;
acc = positions[index * SIZE];

secondIndex = distanceData.b;
acc *= positions[secondIndex * SIZE];

Console.WriteLine(acc);


readonly struct Comparer : IComparer<(int, int, float distance)> {
    public readonly int Compare((int, int, float distance) x, (int, int, float distance) y) {
        return x.distance.CompareTo(y.distance);
    }
}

