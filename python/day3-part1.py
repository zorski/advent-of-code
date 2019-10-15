import string
import os

input_path = os.path.join(os.getcwd(), 'input', 'day3-part1-testinput.txt')
claims = [line.rstrip('\n') for line in open(input_path)]
parsed_claims = []

def parse_coordinates(coordinates: string):
    coordinates_set = set()
    start_point = tuple(coordinates.split(':')[0].strip().split(','))
    c = tuple(coordinates.split(':')[1].strip().split('x'))

    for i in range(1, int(c[0]) + 1):
        for j in range(1, int(c[1]) + 1):
            coordinates_set.add((int(start_point[0]) + i, int(start_point[1]) + j))

    return coordinates_set


def parse_claim(claim: string):
    claim_id = int(claim.split('@')[0].strip().lstrip('#'))
    coordinates = parse_coordinates(claim.split('@')[-1].strip())

    return {'id': claim_id, 'coordinates': coordinates}


for claim in claims:
    parsed_claims.append(parse_claim(claim))

print('echo')







