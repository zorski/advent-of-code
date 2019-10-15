import string
import os

input_path = os.path.join(os.getcwd(), 'input', 'day2-part1.txt')
i = 0


def compare_ids(first: string, second: string) -> int:
    i = 0
    cnt = 0
    index = -1

    if len(first) != len(second):
        return -1

    while i < len(first):
        if first[i] != second[i]:
            if cnt == 0:
                cnt += 1
                index = i
            else:
                cnt += 1
                break
        i += 1

    return -1 if cnt > 1 else index


def remove_char_by_index(s, ix):
    return s[:ix] + s[ix + 1:]


ids = [line.rstrip('\n') for line in open(input_path)]

for i in range(len(ids)):
    for j in range(i + 1, len(ids)):
        index = compare_ids(ids[i], ids[j])
        if not index == -1:
            print(remove_char_by_index(ids[i], index))
