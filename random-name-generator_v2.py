#!/usr/bin/python3

import random

print("\nThis is the ", u"\u2615", "-meetup group generator. Your session members are:\n")

previous_group = list()

with open('/Volumes/Elements/projects/coffee-sesh/previous-group.txt', 'r') as f:
    for line in f:
        line = line.split()
        previous_group.append(line)

count = 1

while any(previous_group) == True:
    try:
        group = list()
        idx = random.sample(range(0, len(previous_group)), 4)
        print(idx)
        for i in idx:
            member = random.choice(previous_group[i])
            group.append(member)
            previous_group[i] = [x for x in previous_group[i] if x != member]
        print(count, group, "\n", sep="\t")
        count+=1
    except IndexError:
        remainder = [x for x in previous_group if x != []]
        remainder_flat = [x for i in remainder for x in i]
        remainder_all = group+remainder_flat
        random.shuffle(remainder_all)
        split = [remainder_all[i:i + 4] for i in range(0, len(remainder_all), 4)]
        for i in split:
            print("index error")
            print(count, i, "\n", sep="\t")
            count+=1
        break



