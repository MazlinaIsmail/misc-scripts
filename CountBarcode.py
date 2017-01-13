# Jan 2017

##### Pseudocode #####
# read in all files in Decombined folder
# for each file
# read in 9th column -> barcode sequence
# take only barcode; [8:14], [23:29]; concat
# count
# combine multiple plots -> subplots

##### Py packages #####
from __future__ import division
from os import listdir
from os.path import isfile, join
import collections as coll
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 8})
import matplotlib.mlab as mlab
import numpy as np
import sys
import gzip

##### Start #####

path = str(sys.argv[1])
onlyfiles = [f for f in listdir(path) if isfile(join(path, f)) if "n12" in f]

# setting the y length of subplot
N = len(onlyfiles)/3

if N.is_integer() == False:
    N += 1

##### Plotting #####

fig = plt.figure(figsize=(10,8))
fig.suptitle("Number of times barcode is present", fontsize=10)

for infile, index in zip(onlyfiles, np.arange(len(onlyfiles))):
    bcseq = []
    with gzip.open(path+infile, 'r') as f:
        lines = f.read().splitlines()

        for l in lines:
            spl = l.split(", ")
            first_bc = spl[8][8:14]
            second_bc = spl[8][23:29]
            bcseq.append(first_bc + second_bc)

    # count how many times each barcode is used
    count =  coll.Counter(bcseq)
    total = sum(count.values()) # => number of reads decombined
    data = coll.Counter(count.values()) # # => count the counts

    x, y, xlabs = [], [], []

    for k, v in data.items():
        x.append(k)
        y.append(v)
        xlabs.append(str(k))

    plt.subplot(int(N), 3, index+1)
    plt.bar(x, y, align='center', color='grey')
    plt.title(infile)
    plt.xticks(np.arange(min(x), 31, 5))
    plt.xlim(0, 30)

fig.tight_layout()
fig.subplots_adjust(top=0.88)
plt.savefig(str(sys.argv[2]), dpi=600)
