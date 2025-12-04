import time

def integrale(f, a, b, n):
    accu = 0.0
    x = a
    h = (b - a) / n
    while (x< b):
        accu = accu + f(x) ;
        x = x+ h
    return accu
  
def poly(x):
    return x * x + 2 * x + 1

def test_integrales(n):
    r = 0.0
    i = 0
    while (i< n):
        r= r + integrale(poly,0.0,1.0,100)
        i = i + 1
    return r

start = time.monotonic()
test_integrales(4)
stop = time.monotonic()
print(stop-start)
