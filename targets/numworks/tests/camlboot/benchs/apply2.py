import time
# from microbit import *

double = lambda f : lambda x : f (f(x))
quad = lambda n : double(double)(n)
oct = lambda n : quad(quad)(n)
succ = lambda n : n + 1

def test_apply(n):
    i = 0
    r = 0
    while (i < n):
        r = r + double(quad(succ))(n-i )
        i = i + 1
    print(r)
    return r

start = time.monotonic()
test_apply(1000)
stop = time.monotonic()
print(stop-start)
