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
        state = (state + parse()) % 100
        if state == 0:
            count += 1
except EOFError:
    print(count)
