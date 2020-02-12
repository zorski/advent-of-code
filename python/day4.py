import string
import datetime
import os
import re


input_path = os.path.join(os.getcwd(), 'input', 'day4-input.txt')
shift_records = [line.rstrip('\n') for line in open(input_path)]


def parse_shift_records(records):
    parsed_records = []
    for record in records:
        date = datetime.datetime.strptime(record[1:17], '%Y-%m-%d %H:%M')
        action = record[18:].strip()
        parsed_records.append({'date': date, 'action': action})

    return parsed_records


parsed_shift_records = parse_shift_records(shift_records)
# sort records
parsed_shift_records = sorted(parsed_shift_records, key=lambda student: student['date'])

re_match_guard = re.compile('^Guard\s#(?P<id>\d+)\sbegins\sshift$')
guards = {}


for record in parsed_shift_records:
    if record['action'].startswith('Guard'):
        guard_match = re_match_guard.match(record['action'])
        guard_id = int(guard_match['id'])

    if guard_match and int(guard_match['id']) not in guards:

        minutes = [0]*61
        guards.update({guard_id: minutes})

    if record['action'] == 'falls asleep':
        minute_asleep = record['date'].minute

    if record['action'] == 'wakes up':
        minute_wakes_up = record['date'].minute
        for minute in range(minute_asleep, minute_wakes_up):
            guards[guard_id][minute] += 1
        guards[guard_id][-1] += (minute_wakes_up - minute_asleep)


print("TEST")

max_guard_id = 0
max_guard_minutes = 0
for guard_id, guard_minutes in guards.items():
    if guard_minutes[-1] > max_guard_minutes:
        max_guard_minutes = guard_minutes[-1]
        max_guard_id = guard_id

max_guard_minute = guards[max_guard_id].index(max(guards[max_guard_id][0:-1]))

print("{} * {} = {}".format(max_guard_id, max_guard_minute, max_guard_id * max_guard_minute))

# PART 2: Of all guards, which guard is most frequently asleep on the same minute?
max_guard_id = 0
max_guard_minutes = 0
max_guard_index_of_minute = 0

for guard_id, guard_minutes in guards.items():
    if max(guard_minutes[0:-1]) > max_guard_minutes:
        max_guard_minutes = max(guard_minutes[0:-1])
        max_guard_id = guard_id
        max_guard_index_of_minute = guard_minutes.index(max(guard_minutes[0:-1]))

print("{} * {} = {}".format(max_guard_id, max_guard_index_of_minute, max_guard_id * max_guard_index_of_minute))