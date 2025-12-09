string? line;
string[] position;
long acc;
float closestDistance, distance;
List<long> positions = [];
List<ValueTuple<int, int>> connected = [];
List<List<int>> circuits = [];
int index, secondIndex, bufferIndex, secondBufferIndex, nodeIndex, multiplyCount, largestCount, largestIndex;
ValueTuple<int, int> closest, tuple;
List<int> buffer, secondBuffer;

const int SIZE = 3;
const int CONNECTIONS = 1000;
const int TO_MULTIPLY = 3;

READ:
line = Console.ReadLine();
if (string.IsNullOrEmpty(line))
    goto COMPUTE_CONNECTIONS;
position = line.Split(",");
index = 0;
READ_COMPONENT:
positions.Add(long.Parse(position[index]));
index++;
if (index < SIZE)
    goto READ_COMPONENT;
goto READ;

COMPUTE_CONNECTIONS:
closestDistance = long.MaxValue;
index = 0;
closest = new();

COMPUTE_NEXT:
secondIndex = index + SIZE;

COMPUTE_SECOND:
if (connected.Contains((index, secondIndex)))
    goto COMPUTE_NEXT_PAIRED;

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
if (distance > closestDistance)
    goto COMPUTE_NEXT_PAIRED;

closestDistance = distance;
closest = (index, secondIndex);

COMPUTE_NEXT_PAIRED:
secondIndex += SIZE;
if (secondIndex < positions.Count)
    goto COMPUTE_SECOND;
index += SIZE;
if (index < positions.Count - SIZE)
    goto COMPUTE_NEXT;

connected.Add(closest);

if (connected.Count < CONNECTIONS)
    goto COMPUTE_CONNECTIONS;

index = 0;

COMPUTE_CIRCUITS:
tuple = connected[index];
buffer = [tuple.Item1, tuple.Item2];
circuits.Add(buffer);
index += 1;
if (index < connected.Count)
    goto COMPUTE_CIRCUITS;

TRY_TO_MERGE_ALL:
index = 0;

TRY_TO_MERGE:
buffer = circuits[index];
secondIndex = index + 1;

TRY_TO_MERGE_SECOND:
secondBuffer = circuits[secondIndex];

bufferIndex = 0;

COMPARE:
nodeIndex = buffer[bufferIndex];
secondBufferIndex = 0;

COMPARE_SECOND:
if (secondBuffer[secondBufferIndex] == nodeIndex)
    goto DO_MERGE;

secondBufferIndex++;
if (secondBufferIndex < secondBuffer.Count)
    goto COMPARE_SECOND;

bufferIndex++;
if (bufferIndex < buffer.Count)
    goto COMPARE;

secondIndex++;
if (secondIndex < circuits.Count)
    goto TRY_TO_MERGE_SECOND;

index++;
if (index < circuits.Count - 1)
    goto TRY_TO_MERGE;

multiplyCount = TO_MULTIPLY;
acc = 1;

MULTIPLY:
largestCount = int.MinValue;
largestIndex = 0;
index = 0;

TRY_TO_MARK:
buffer = circuits[index];
if (buffer.Count < largestCount)
    goto TRY_TO_MARK_NEXT;

largestCount = buffer.Count;
largestIndex = index;

TRY_TO_MARK_NEXT:
index++;
if (index < circuits.Count)
    goto TRY_TO_MARK;

circuits.RemoveAt(largestIndex);
acc *= largestCount;

multiplyCount--;
if (multiplyCount > 0)
    goto MULTIPLY;

Console.WriteLine(acc);
return;

DO_MERGE:
secondBufferIndex = 0;

DO_MERGE_START:

nodeIndex = secondBuffer[secondBufferIndex];
bufferIndex = 0;

CHECK_NEXT:
if (buffer[bufferIndex] == nodeIndex)
    goto DO_MERGE_NEXT;

bufferIndex++;
if (bufferIndex < buffer.Count)
    goto CHECK_NEXT;

buffer.Add(nodeIndex);

DO_MERGE_NEXT:
secondBufferIndex++;
if (secondBufferIndex < secondBuffer.Count)
    goto DO_MERGE_START;

circuits.RemoveAt(secondIndex);
goto TRY_TO_MERGE_ALL;
