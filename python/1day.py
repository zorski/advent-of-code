import os

path = os.path.join(os.getcwd(), '1day-input.txt')
sum_of_frequencies = 0

with open(file=path) as f:
    for line in f:
        sum_of_frequencies += int(line)

print(sum_of_frequencies)

