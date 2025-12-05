import math

def parse():
    x = input()
    if not x:
        raise EOFError()
    value = int(x[1:])
    if x[0] == 'L':
        return -value
    return value

count = 0
try:
    state = 50
    while True:
        order = parse()
        count += int(abs(order) / 100)
        was_zero = state == 0
        state += int(math.copysign(abs(order) % 100, order))
        if state == 0:
            count += 1
        elif state > 99:
            count += 1
            state = state % 100
        elif state < 0:
            if not was_zero:
                count += 1
            state = state % 100
        #print(state, order, count)
except EOFError:
    print(count)
