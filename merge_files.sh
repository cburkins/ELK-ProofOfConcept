#!/bin/bash

echo

# temp files
tmp_file=/tmp/merged.$$
file1_valid=/tmp/file1.$$
file2_valid=/tmp/file2.$$


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

echo
echo "            file1 = $file1"
echo "            file2 = $file2"
echo "      merged file = $mergedfile"
echo 


printf "Parsing for valid lines..."
# Look for valid data lines within the file
# Valid lines look like this:
#    3204088,itsbus40,0,Backup,itshru01.backup.jnj.com,"May 15, 2015 9:00:16 AM","May 15, 2015 9:00:50 AM",00:00:34,"208,256",1,"22,653"
# Valid data lines will have a comma followed by a duration within the line
# e.g.    ,00:00:34
# e.g.    ,4:23:00
# Example of non-valid line: Comments at the top and bottom of file
# Example of non-valid line: Occasionally there's a weird line like this:
#    6582438,ncsebus,150,Backup,UNKNOWN,-,"May 20, 2015 12:14:55 PM",13651431295,0,0,0
# NOTE: this technique is also used in the csvload.sh script
cat $file1 | egrep  '\,[0-9][0-9]*:[0-9][0-9]*:[0-9][0-9]*\,' > $file1_valid
cat $file2 | egrep  '\,[0-9][0-9]*:[0-9][0-9]*:[0-9][0-9]*\,' > $file2_valid
echo "done"

file1_line_count=`wc -l $file1 | awk '{print $1}'`
file1_valid_count=`wc -l $file1_valid | awk '{print $1}'`
diff1=`echo "$file1_line_count - $file1_valid_count" | bc`


file2_line_count=`wc -l $file2 | awk '{print $1}'`
file2_valid_count=`wc -l $file2_valid | awk '{print $1}'`
diff2=`echo "$file2_line_count - $file2_valid_count" | bc`

printf "Calculating unique counts..."
overlap_count=`cat $file1_valid $file2_valid | sort | uniq -d | wc -l`
merged_count=`cat $file1_valid $file2_valid | sort | uniq | wc -l`
total_count=`cat $file1_valid $file2_valid | wc -l`
overlap_pct=`echo "scale=4; $overlap_count / $total_count * 100" | bc -l`
merged_pct=`echo "scale=4; $merged_count / $total_count * 100" | bc -l`
echo "done"


printf " file1 line  count = %'10d\n" $file1_line_count
printf " file1 valid count = %'10d (-%d)\n" $file1_valid_count $diff1
printf " file2 line  count = %'10d\n" $file2_line_count
printf " file2 valid count = %'10d (-%d)\n" $file2_valid_count $diff2
printf "       total count = %'10d\n" $total_count
printf "      merged count = %'10d (%05.2f%%)\n" $merged_count $merged_pct
printf "     overlap count = %'10d (%05.2f%%)\n" $overlap_count $overlap_pct
echo

echo "Hit <return> to continue..."
read
printf "Merging two input files and creating output file..."
cat $file1_valid $file2_valid | sort | uniq > $mergedfile
echo "done"
echo

merged_count=`wc -l $mergedfile | awk '{print $1}'`
printf "    merged count = %'.f\n" $merged_count
echo

/bin/rm -f $tmp_file $file1_valid $file2_valid

