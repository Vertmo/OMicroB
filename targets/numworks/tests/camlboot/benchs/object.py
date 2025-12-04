import time

class Point:
    def __init__(self, x,y):
        self.x = x
        self.y = y
    
    def sym(self):
        return (Point(-self.x,-self.y))

start = time.monotonic()
for i in range(0,100):
    o = Point(10,10)
    for k in range (0,10):
        o.sym()
stop=time.monotonic()
print(stop-start)
