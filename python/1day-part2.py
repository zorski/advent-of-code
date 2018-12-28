import os

path = os.path.join(os.getcwd(), '1day-input.txt')
current_sum = 0
frequency_found = False
sums = set()

with open(file=path, mode='r') as file:
    frequencies = file.readlines()
    while not frequency_found:
        for fr in frequencies:
            current_sum += int(fr)
            if current_sum in sums:
                print(current_sum)
                frequency_found = True
                break
            else:
                sums.add(current_sum)


