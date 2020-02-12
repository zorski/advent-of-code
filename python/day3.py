import string
import os

input_path = os.path.join(os.getcwd(), 'input', 'day3-input.txt')
claims = [line.rstrip('\n') for line in open(input_path)]
parsed_claims = []


def parse_coordinates(coordinates: string):
    coordinates_list = list()
    start_point = tuple(coordinates.split(':')[0].strip().split(','))
    c = tuple(coordinates.split(':')[1].strip().split('x'))

    for i in range(1, int(c[0]) + 1):
        for j in range(1, int(c[1]) + 1):
            coordinates_list.append((int(start_point[0]) + i, int(start_point[1]) + j))

    return coordinates_list


def parse_claim(claim: string):
    claim_id = int(claim.split('@')[0].strip().lstrip('#'))
    coordinates = parse_coordinates(claim.split('@')[-1].strip())

    return {'id': claim_id, 'coordinates': coordinates}


for claim in claims:
    parsed_claims.append(parse_claim(claim))


counter = 0
coords = set()
already_counted = set()
overlapping_ids = set()

for parsed_claim in parsed_claims:
    for coord in parsed_claim['coordinates']:
        if coord in coords and coord not in already_counted:
            counter += 1
            already_counted.add(coord)
            overlapping_ids.add(parsed_claim['id'])
        else:
            coords.add(coord)


print("There are {} square inches of fabric within two or more claims".format(str(counter)))

# Part Two
# What is the ID of the only claim that doesn't overlap?

# matrix 1000x1000 - filled with "0"
material = [[0 for i in range(1000)] for j in range(1000)]

for parsed_claim in parsed_claims:
    claim_id = parsed_claim['id']

    for coordinate in parsed_claim['coordinates']:
        x = coordinate[0] - 1
        y = coordinate[1] - 1

        if material[x][y]:
            overlapping_ids.add(material[x][y])
            overlapping_ids.add(claim_id)
        else:
            material[x][y] = claim_id


all_claims_ids = {claim['id'] for claim in parsed_claims}
not_overlapping_id = all_claims_ids.difference(overlapping_ids).pop()
print("Claim that is not overlapping with any other one has an id of {}".format(not_overlapping_id))






