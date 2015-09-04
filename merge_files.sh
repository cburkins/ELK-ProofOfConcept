#!/bin/bash

tmp_file=/tmp/merged.$$

if [ $# -ne 3 ]; then
   echo
   echo "   $0 <file1> <file2> <merged-file>"; echo; exit

fi
file1=$1
file2=$2
mergedfile=$3

if [ ! -f $file1 ]; then
   echo
   echo "   Error: $file1 does not exist"
   echo; exit
fi

if [ ! -f $file2 ]; then
   echo
   echo "   Error: $file2 does not exist"
   echo; exit
fi


file1_line_count=`wc -l $file1 | awk '{print $1}'`
file2_line_count=`wc -l $file2 | awk '{print $1}'`
overlap_count=`cat $file1 $file2 | sort | uniq -d | wc -l`
merged_count=`cat $file1 $file2 | sort | uniq -u | wc -l`
total_count=`cat $file1 $file2 | wc -l`

#delta=`echo "$count_orig - $count_good" | bc`

echo
echo "            file1 = $file1"
echo "            file2 = $file2"
echo "      merged file = $mergedfile"
echo 
printf " file1 line count = %'10d\n" $file1_line_count
printf " file2 line count = %'10d\n" $file2_line_count
printf "      total count = %'10d\n" $total_count
printf "     merged count = %'10d\n" $merged_count
printf "    overlap count = %'10d\n" $overlap_count
echo

echo "Hit <return> to continue..."
read
echo "Go..."
echo 

cat $file1 $file2 | sort | uniq -u > $mergedfile

merged_count=`wc -l $mergedfile | awk '{print $1}'`
printf "    merged count = %'.f\n" $merged_count
echo

/bin/rm -f $tmp_file

