import os
import string

input_path = os.path.join(os.getcwd(), 'input', 'day2-part1.txt')
letter_frequencies = []


def count_letter(line):
    alphabet = dict.fromkeys(string.ascii_lowercase, 0)
    for letter in line:
        alphabet[letter] += 1

    three_letters = 1 if len({k: v for k, v in alphabet.items() if v == 3}) > 0 else 0
    two_letters = 1 if len({k: v for k, v in alphabet.items() if v == 2}) > 0 else 0

    return three_letters, two_letters


with open(file=input_path, mode='r') as ids:
    for i in ids:
        letter_frequency = count_letter(i.rstrip('\n'))
        letter_frequencies.append(letter_frequency)

threes = len([x for x in letter_frequencies if x[0] == 1])
twos = len([x for x in letter_frequencies if x[1] == 1])

print(threes, '*', twos, '=', threes * twos)
