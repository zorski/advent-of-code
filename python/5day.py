from string import *

def test_letters(a, b):
    """
    tests if letters are same but different case, e.g:
    'a' AND 'A' -> True
    'a' AND 'B' -> False
    'a' AND 'b' -> False
    'a' AND 'a' -> False
    """
    if abs(ord(a) - ord(b)) == 32:
        result = True
    else:
        result = False
    return result

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