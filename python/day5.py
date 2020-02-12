import os
import string
from collections import deque

class PolymerStack:
    def __init__(self):
        self.items = deque()

    def empty(self):
        if len(self.items) == 0:
            return True
        else:
            return False

    def push(self, element):
        self.items.append(element)

    def pop(self):
        return self.items.pop()

    def peek(self):
        return self.items[-1]

    def size(self):
        return len(self.items)


input_path = os.path.join(os.getcwd(), 'input', 'day5-input.txt')

with open(input_path, mode='r') as myfile:
    polymer = myfile.read()


def test_letters(l1, l2):
    """
    tests if letters are same but different case, e.g:
    'a' AND 'A' -> True
    'a' AND 'B' -> False
    'a' AND 'b' -> False
    'a' AND 'a' -> False
    """
    if abs(ord(l1) - ord(l2)) == 32:
        result = True
    else:
        result = False
    return result


def react_polymer(polymer):
    st_buffer = PolymerStack()
    st_buffer.push(' ')
    for letter in polymer:
        if test_letters(letter, st_buffer.peek()):
            st_buffer.pop()
        else:
            st_buffer.push(letter)

    return len(st_buffer.items) - 1


print("Reacted polymer: {}".format(react_polymer(polymer)))


# PART2: What is the length of the shortest polymer you can produce by removing all units of exactly one type and fully reacting the result?
min_polymer = 1000000
for rletter in string.ascii_lowercase:
    temp_polymer = polymer.replace(rletter, '')
    temp_polymer = temp_polymer.replace(rletter.upper(), '')
    reacted = react_polymer(temp_polymer)
    if reacted < min_polymer:
        min_polymer = reacted

print("The length of the shortest polymer by removing one letter is {}".format(min_polymer))



