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


def react_polymer(polymer):
    i = 0
    i = 0 + max(0, (i - 1))
    while i < len(polymer):
        if test_letters(polymer[i], polymer[i+1]):
            react_polymer(polymer.)
