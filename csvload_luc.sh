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

# Look for valid data lines within the file
# Valid lines look like this:
#    itsbus30,8436061,rau0044p.jnj.com,User backup,4/2/2015 11:37:24 PM,4/2/2015 11:41:08 PM,245727232,10069,0
# Valid data lines will have a comma followed by a date
# e.g.    ,4/2/2015
# e.g.    ,11/2/2015
# Example of non-valid line: Comments at the top and bottom of file
# Example of non-valid line: Occasionally there's a weird line like this:
#    6582438,ncsebus,150,Backup,UNKNOWN,-,"May 20, 2015 12:14:55 PM",13651431295,0,0,0
# NOTE: this technique is also used in the merge_files.sh script
cat $input_file | egrep  '\,[0-9][0-9]*\/[0-9][0-9]*\/[0-9][0-9][0-9][0-9] [0-9][0-9]*:[0-9][0-9]:[0-9][0-9]' | egrep -v '\/[0-9][0-9][0-9][0-9]\,' > $tmp_file

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

# Load the data lines into logstash, using my csvload configuration file
cat $tmp_file | /opt/logstash/bin/logstash -f ./csvload_luc.conf

/bin/rm $tmp_file

