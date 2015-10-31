#!/bin/bash

tmp_file1=/tmp/logstash_input.1.$$
tmp_file2=/tmp/logstash_input.2.$$
grep_duration=./grep_duration
grep_even_apostrophes=./apostrophe_pairs

# Verify correct number of arguments
if [ $# -ne 1 ]; then
   echo
   echo "   $0 <input-file>"; echo; exit

fi
input_file=$1

# Verify that input exists
if [ ! -f $input_file ]; then
   echo
   echo "   Error: $input_file does not exist"
   echo; exit
fi

cat $input_file | grep "2015"  > $tmp_file1

count_orig=`wc -l $input_file | awk '{print $1}'`
count_good=`wc -l $tmp_file1 | awk '{print $1}'`
delta=`echo "$count_orig - $count_good" | bc`

echo
echo "         Input file = $input_file"
echo "Record count (orig) = $count_orig"
echo "Record count (good) = $count_good (delta of $delta)"
echo

echo "Hit <return> to continue..."
read
echo "Go..."
echo 

# Load the data lines into logstash, using my csvload configuration file
cat $tmp_file1 | /opt/logstash/bin/logstash -f ./csvload_sn.conf

/bin/rm $tmp_file1

