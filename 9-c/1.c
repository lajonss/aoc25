#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
  int x, y;
  struct Node *next;
} Node;

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

long surface(Node *a, Node *b) {
  long diffX = abs(a->x - b->x) + 1;
  int diffY = abs(a->y - b->y) + 1;
  return diffX * diffY;
}

int main() {
  Node *first = readAll();
  long largest = 0;
  for (Node *a = first; a != NULL; a = a->next) {
    for (Node *b = a->next; b != NULL; b = b->next) {
      long current = surface(a, b);
      if (current > largest) {
        largest = current;
      }
    }
  }
  printf("%ld\n", largest);
}
