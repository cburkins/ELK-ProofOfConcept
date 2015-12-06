#!/bin/bash

tmpfile=/tmp/csv-scrub-$$


echo
echo

inputfile=$1
if [ ! -f $inputfile ]; then
   echo "Error: Input file does not exist: $inputfile"
   exit
fi

file=`basename $inputfile`
dir=`dirname $1`

file=$(basename "$inputfile")
extension="${file##*.}"
justfilename="${file%.*}"

echo "Extension: $extension"
echo "filename: $justfilename"

outputfile="${dir}/${justfilename}-scrubbed.${extension}"

echo "Running iconv (to clean up character set)..."
cat $inputfile | iconv -c -t UTF-8 > ${tmpfile}
echo "Running csvclean..."
/usr/bin/csvclean ${tmpfile}

mv ${tmpfile}_out.csv $outputfile

echo
echo "Output file created: $outputfile"
echo
echo "Input:  $(wc -l $inputfile)"
echo "Output: $(wc -l $outputfile)"
echo
