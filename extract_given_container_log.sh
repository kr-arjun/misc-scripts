#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Invalid parameters. Usage: bash extract_given_container_log.sh <containerId> <application Log File>"
  exit 1
fi

container_id=$1
application_log_file=$2

container_start_regex="^Container: ${container_id} on .*$"
container_all_start_regex="^Container: container_.* on .*$"

container_info=""
container_info_flag=0
error_info=""
container_file=""

while IFS= read line
do
 if [[ $line =~ $container_start_regex  ]];
 then 
  container=`echo $line | grep -ow "container[a-z0-9_]*"`
  host_id=`echo $line |  cut -d " " -f4`
  container_file=${container}_${host_id}.log
  echo > $container_file
  container_info_flag=1
  continue
 fi
 
 if [[ $container_info_flag == 1 ]];
  then
    if [[ $line =~ $container_all_start_regex  ]];
    then
      break
    else
      echo $line >> $container_file
    fi
 fi
done < $application_log_file


echo "Done.Check file: $container_file"
