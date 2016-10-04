# Oct 2016
# MI

##### Pseudocode #####

# read in index file, keep in list = order of sample names
# assuming all log files are in one Logs folder
# for each filename in list
# look for Decombinator log files
# get output
# look for Collapsing log files
# get output
# print to output file

# output:
 # sample,NumberReadsInput,NumberReadsDecombined,PercentReadsDecombined,UniqueDCRsPassingFilters,TotalDCRsPassingFilters,PercentDCRPassingFilters(withbarcode),UniqueDCRsPostCollapsing,TotalDCRsPostCollapsing,PercentUniqueDCRsKept,PercentTotalDCRsKept,AverageInputTCRAbundance,AverageOutputTCRAbundance,AverageRNAduplication
 
# output comes from:
 # field 1 = index_file, field 2-4 = Decombinator log, field 5-14 = Collapsing log

##### How to run #####

# python CopyPasteDcrLogVals.py full/path/to/Logs/folder/ full/path/to/index/file outfile.csv

# NB assumes that all Log files are in one Log folder
#    prints the output file to whatever directory you are in
 
##### Py packages #####

from os import listdir
from os.path import isfile, join
import sys
import fileinput

##### Fx blocks #####

def readFile(path, infile, pattern):

    with open(path+infile, 'r') as f:
        lines = f.read().splitlines()

        for l in lines:
            if pattern in l:
                spl = l.split(',')
                val = spl[1]

                return val
    
 
##### Start #####

pathToLogs = str(sys.argv[1]) # full path to Logs folder
indexFile = str(sys.argv[2]) # full path to index_file

onlyfiles = [f for f in listdir(pathToLogs) if isfile(join(pathToLogs, f))]

fields = ["sample",
          "NumberReadsInput",
          "NumberReadsDecombined",
          "PercentReadsDecombined",
          "UniqueDCRsPassingFilters",
          "TotalDCRsPassingFilters",
          "PercentDCRPassingFilters(withbarcode)",
          "UniqueDCRsPostCollapsing",
          "TotalDCRsPostCollapsing",
          "PercentUniqueDCRsKept",
          "PercentTotalDCRsKept",
          "AverageInputTCRAbundance",
          "AverageOutputTCRAbundance",
          "AverageRNAduplication"]

sampleNam = []

with open(indexFile, 'r') as f:
    lines = f.read().splitlines()

    for l in lines:
        spl = l.split(',')
        sampleNam.append(spl[0])

out = []

for i in sampleNam:
    string = [i]
    for j in onlyfiles:
        if i in j:
            if "Decombinator" in j:
                for patt in fields[1:4]:
                     string2 = readFile(pathToLogs, j, patt)
                     string.append(string2)
    for j in onlyfiles:
        if i in j:
            if "Collapsing" in j:
                for patt in fields[4:]:
                     string2 = readFile(pathToLogs, j, patt)
                     string.append(string2)

    outStr = ','.join(string)
    out.append(outStr)

with open(str(sys.argv[3]), 'w') as f:
    for string in out:
        f.write("%s\n" % string)

for line in fileinput.input([str(sys.argv[3])], inplace=True):
    if fileinput.isfirstline():
        print ','.join(fields)
    print line,
