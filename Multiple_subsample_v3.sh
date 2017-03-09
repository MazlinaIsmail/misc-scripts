#!/bin/bash
##### Pseudocode #####
# read in two files
# for each file
# sum freq
# whichever is the smaller value
# use that for the random sample script
# multipe subsample the bigger file
# To run
# sh Multiple_subsample.sh
# a few caveats
# 1. script must be where the .freq files are
# 2. RandomlySample.py must also be in same directory
#
# ask user for some input
# format: file_name1 filename2 folder_name n
echo Specify paired file names, folder name and n times
read file1 file2 folder n
#
# counts the sum of freqs and assigns it to a variable
# assumes freq files are zipped
# val1=($(gunzip -c $file1 | cat | awk '{sum+=$6} END {print sum}'))
# val2=($(gunzip -c $file2 | cat | awk '{sum+=$6} END {print sum}'))
# if unzipped, comment the two lines above
# and uncomment the two below
val1=($(cat $file1 | awk '{sum+=$6} END {print sum}'))
val2=($(cat $file2 | awk '{sum+=$6} END {print sum}'))
#
# gets the smaller of the two values
min=$(($val1<$val2?$val1:$val2))
mkdir ./"$folder"
#
# checks if the min value equal to file1 or file2
# if the min value equals to the sum of freqs in file1
# takes file2 and subsamples based on the min value == sum of file1
# if not, swap the other way around
# change the path of the python script to full/path/to/RandomlySample.py
if [ "$min" -eq "$val1" ]
   then
       for i in $(seq 1 $n)
       do
	   python ./RandomlySample.py -in $file2 -n $val1 -dz True -pf subsampled"$i"_ -s True
	   mv subsampled* ./"$folder"
       done
else
    for i in $(seq 1 $n)
    do
	python ./RandomlySample.py -in $file1 -n $val2 -dz True -pf subsampled"$i"_ -s True
	mv subsampled* ./"$folder"
    done
fi

