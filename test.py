import matplotlib.path as mpltPath

p = [[0.01, 0.01], [0.01, 2.01], [2.01, 2.01], [2.01, 0.01], [0.01, 0.01]]
path = mpltPath.Path(p)

fp = [1.01,1.01]
outp = [3.01,3.01]
inside = path.contains_point(fp)
print(inside)
inside2 = path.contains_point(outp)
print(inside2)