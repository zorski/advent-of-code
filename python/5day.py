from string import *


def collapse(s):
    p = ['.']
    for u in s:
        v = p[-1]
        if v != u and v.lower() == u.lower():
            p.pop()
        else:
            p.append(u)
    return len(p) - 1


s = open(r'C:\Users\mzaor\moje\AdventOfCode\ps\inputs\5day.txt').read().strip()
s = 'xabcCdDBA'
print(collapse(s))
print(min(collapse(c for c in s if c.lower() != x) for x in ascii_lowercase))