
#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Invalid parameters. Usage: bash extract_pattern.sh <file_name> <search pattern - eg: word1|word2 >"
  exit 1
fi

application_log_file=$1

filename=$(basename -- "$application_log_file")
filename="${filename%.*}"

search_pattern=$2
output_file="$filename"_`echo $search_pattern| sed 's/\|/_/g'`
pattern_found_flag="false"
search_regex="^.*($search_pattern).*$"

while IFS= read line
do

 #echo "Processing $line"
 current_ts=`echo $line | grep -ow '^[0-9/\-]* [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'`
 pattern_found_current="false"

 if [[ $line =~ $search_regex  ]];
  then
    pattern_found_flag="true"
    pattern_found_current="true"
    echo "pattern found"
 elif [[ ! -z "$current_ts" && "$pattern_found_current" = "false" ]];
 then
    pattern_found_flag="false"
    echo "pattern not found"
 fi

 if [[ "$pattern_found_flag" = "true" ]];
 then
    echo $line >> $output_file
 fi
done < $application_log_file

