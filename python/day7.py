import os
import string

input_path = os.path.join(os.getcwd(), 'input', 'day7-input.txt')
steps_list = [line.rstrip('\n') for line in open(input_path)]
steps = {i: set() for i in string.ascii_uppercase}
done = set()
assembly_sequence = []


def read_steps(s):
    return {'parent': s[5], 'child': s[36]}


for step in steps_list:
    parsed_step = read_steps(step)
    steps[parsed_step['child']].add(parsed_step['parent'])


while steps:
    nodes = []
    for step in steps.items():
        if step[1].issubset(done):
            nodes += step[0]

    letter = min(nodes)
    assembly_sequence.append(letter)
    done.add(letter)
    steps.pop(letter)


print(''.join(assembly_sequence))

