#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
  int x, y;
  struct Node *next;
} Node;

typedef struct Colors {
  int offsetX, offsetY, rowSize;
  bool *colors;
} Colors;

Node *readNext() {
  int x, y;
  int read = scanf("%d,%d", &x, &y);
  if (read != 2) {
    return NULL;
  }

  Node *node = (Node *)malloc(sizeof(Node));
  node->x = x;
  node->y = y;
  return node;
}

Node *readAll() {
  Node *first = readNext();
  Node *current = first;
  while (current != NULL) {
    current->next = readNext();
    current = current->next;
  }
  return first;
}

int min(int a, int b) { return a < b ? a : b; }

int max(int a, int b) { return a > b ? a : b; }

bool *getOffset(Colors colors, int x, int y) {
  return &colors.colors[(y - colors.offsetY) * colors.rowSize + x -
                        colors.offsetX];
}

bool isMarked(Colors colors, Node node) {
  return *getOffset(colors, node.x, node.y);
}

void mark(Colors colors, Node node) {
  *getOffset(colors, node.x, node.y) = true;
}

int signum(int x) {
  if (x > 0) {
    return 1;
  } else if (x < 0) {
    return -1;
  } else {
    return 0;
  }
}

Node getStepX(Node from, Node to) {
  Node step;
  step.x = signum(to.x - from.x);
  step.y = 0;
  return step;
}

Node getStepY(Node from, Node to) {
  Node step;
  step.x = 0;
  step.y = signum(to.y - from.y);
  return step;
}

Node getStep(Node from, Node to) {
  if (from.x == to.x) {
    return getStepY(from, to);
  } else {
    return getStepX(from, to);
  }
}

bool equals(Node a, Node b) { return a.x == b.x && a.y == b.y; }

Node add(Node a, Node b) {
  Node output;
  output.x = a.x + b.x;
  output.y = a.y + b.y;
  return output;
}

void markPath(Colors colors, Node from, Node to) {
  Node step = getStep(from, to);
  while (!equals(from, to)) {
    mark(colors, from);
    from = add(from, step);
  }
  mark(colors, to);
}

Colors color(Node *first) {
  int minX = INT_MAX, maxX = INT_MIN, minY = INT_MAX, maxY = INT_MIN;
  for (Node *node = first; node != NULL; node = node->next) {
    Node current = *node;
    minX = min(current.x, minX);
    maxX = max(current.x, maxX);
    minY = min(current.y, minY);
    maxY = max(current.y, maxY);
  }

  int sizeX = maxX - minX + 1;
  int sizeY = maxY - minY + 1;

  Colors output;
  output.offsetX = minX;
  output.offsetY = minY;
  output.rowSize = sizeX;
  output.colors = (bool *)calloc(sizeX * sizeY, sizeof(bool));
  Node *pointer;
  for (pointer = first; pointer->next != NULL; pointer = pointer->next) {
    markPath(output, *pointer, *pointer->next);
  }
  markPath(output, *pointer, *first);
  return output;
}

bool isValidPath(Node from, Node step, Node to, Colors colors) {
  for (; !equals(from, to); from = add(from, step)) {//todo - equals axis-wise
    if (!isMarked(colors, from)) {
      return false;
    }
  }
  return true;
}

bool isValid(Node a, Node b, Colors colors) {
  return isValidPath(a, getStepX(a, b), b, colors) &&
         isValidPath(a, getStepY(a, b), b, colors) &&
         isValidPath(b, getStepX(b, a), a, colors) &&
         isValidPath(b, getStepY(b, a), a, colors);
}

long surface(Node a, Node b, Colors colors) {
  if (!isValid(a, b, colors)) {
    return 0;
  }

  long diffX = abs(a.x - b.x) + 1;
  int diffY = abs(a.y - b.y) + 1;
  return diffX * diffY;
}

int main() {
  Node *first = readAll();
  Colors colors = color(first);
  long largest = 0;
  for (Node *a = first; a != NULL; a = a->next) {
    for (Node *b = a->next; b != NULL; b = b->next) {
      long current = surface(*a, *b, colors);
      if (current > largest) {
        largest = current;
      }
    }
  }
  printf("%ld\n", largest);
}
