
#!/bin/bash

if [ $# -ne 3 ]
then
  echo "Invalid parameters. Usage: bash extract_between_ts.sh <file_name> <start timestamp> <end timetamp>. Ensure timestamp are in format : YYYY-MM-DD HH:MM:SS"
  exit 1
fi

application_log_file=$1
start_ts=$2
end_ts=$3

if [[ "$start_ts" > "$end_ts" ]] ;
then
    echo "Start timestamp is greater than end timestamp."
    exit 1
fi

# date -d "2015-01-01 10:00:00" +"%a %b  %d %H:%M:%S %Y"



start_ts_epoch=`gdate --date="$start_ts" '+%s'`
end_ts_epoch=`gdate --date="$end_ts" '+%s'`


#start_regex="^[$formatted_start_ts] .*$"
#end_regex="^[$formatted_end_ts] .*$"

valid_ts_range_flag=0
output_file=output.log

while IFS= read line
do

# echo "Processing $line"
 current_ts=`echo $line | grep -ow '^[0-9/\-]* [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'`
 if [[ ! -z "$current_ts"  ]];
 then
   current_ts_epoch=`gdate --date="$current_ts" '+%s'`
   if [[ $? -eq 0 ]];
   then
     if [ $current_ts_epoch -ge "$start_ts_epoch" ] &&  [ $current_ts_epoch -lt  "$end_ts_epoch" ];
     then
       valid_ts_range_flag=1
       echo "in between line $current_ts"
     elif [ $current_ts_epoch -gt  "$end_ts_epoch" ];then
       echo "break condition $current_ts"
      break
     fi
   fi
 fi

 if [[ $valid_ts_range_flag == 1 ]];
 then
    echo $line >> $output_file
 fi
done < $application_log_file

# Parsing is done.

if [[ $valid_ts_range_flag == 1 ]]; then
  echo "Done.Check file: $output_file"
else
  echo "No matching log entries found."
fi
