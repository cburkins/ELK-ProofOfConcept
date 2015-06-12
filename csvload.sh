#!/bin/bash

tmp_file=/tmp/logstash_input.$$

if [ $# -ne 1 ]; then
   echo
   echo "   $0 <input-file>"; echo; exit

fi
input_file=$1

if [ ! -f $input_file ]; then
   echo
   echo "   Error: $input_file does not exist"
   echo; exit
fi

cat $input_file | egrep  '\,[0-9][0-9]*:[0-9][0-9]*:[0-9][0-9]*\,' > $tmp_file

count_orig=`wc -l $input_file | awk '{print $1}'`
count_good=`wc -l $tmp_file | awk '{print $1}'`
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

cat $tmp_file | /opt/logstash/bin/logstash -f ./csvload.conf

/bin/rm $tmp_file

