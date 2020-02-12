import os
import sys
from pprint import pprint as pp

input_path = os.path.join(os.getcwd(), 'input', 'day6-input.txt')
raw_coordinates = [line.rstrip('\n') for line in open(input_path)]
area = [[['X:X', sys.maxsize] for i in range(400)] for j in range(400)]


def parse_coordinates(coordinates):
    parsed_coordinates = []
    for coordinate in coordinates:
        t = tuple(int(i) for i in coordinate.split(','))
        parsed_coordinates.append(t)
    return parsed_coordinates


def manhattan_distance(a: tuple, b: tuple) -> int:
    return abs(a[0] - b[0]) + abs(a[1] - b[1])


coordinates = parse_coordinates(raw_coordinates)

# for each coordinate on the grid 400x400 (hardcoded :/) compare the distance from manhattan_distance function to
# current value
for i in range(400):
    for j in range(400):
        for c in coordinates:
            distance = manhattan_distance(tuple([i, j]), c)
            if distance == area[i][j][-1]:
                area[i][j][0] = '.'
                area[i][j][-1] = distance

            if distance < area[i][j][-1]:
                element = [', '.join([str(i) for i in c]), distance]
                area[i][j] = element

coordinates_for_exclusion = set()

x_zero_axis = set([i[0] for i in area[0] if i[0] != '.'])
x_axis = set([i[0] for i in area[-1] if i[0] != '.'])
coordinates_for_exclusion.update(x_zero_axis)
coordinates_for_exclusion.update(x_axis)

for idx, val in enumerate(area):
    first = val[0][0]
    last = val[-1][0]
    if first != '.':
        coordinates_for_exclusion.add(first)
    if last != '.':
        coordinates_for_exclusion.add(last)

meh_coordinates = set(raw_coordinates)
desired_coordinates = meh_coordinates.difference(coordinates_for_exclusion)

coord_counter = {}
for dc in desired_coordinates:
    coord_counter[dc] = 0


for i in range(400):
    for j in range(400):
        for dc in desired_coordinates:
            if area[i][j][0] == dc:
                coord_counter[dc] += 1

print(max(coord_counter.values()))



