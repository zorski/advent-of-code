import os
import sys
from pprint import pprint as pp

input_path = os.path.join(os.getcwd(), 'input', 'day6-input.txt')
raw_coordinates = [line.rstrip('\n') for line in open(input_path)]
area = [[['X:X', sys.maxsize] for i in range(10)] for j in range(10)]


def parse_coordinates(coordinates):
    parsed_coordinates = []
    for coordinate in coordinates:
        t = tuple(int(i) for i in coordinate.split(','))
        parsed_coordinates.append(t)
    return parsed_coordinates


def manhattan_distance(a: tuple, b: tuple) -> int:
    return abs(a[0] - b[0]) + abs(a[1] - b[1])


coordinates = parse_coordinates(raw_coordinates)
max_manhattan_distance = sys.maxsize

for i in range(10):
    for j in range(10):
        for c in coordinates:
            distance = manhattan_distance(tuple([i, j]), c)
            if distance == area[i][j][-1]:
                area[i][j][0] = '.'
                area[i][j][-1] = distance

            if distance < area[i][j][-1]:
                element = [','.join([str(i) for i in c]), distance]
                area[i][j] = element




pp(area)



