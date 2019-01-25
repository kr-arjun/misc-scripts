
#!/bin/bash
if [ $# -ne 2 ]
then
  echo "Invalid parameters. Usage: bash extract_all_container_log.sh <application Log File> <outputdir>"
  exit 1
fi

file=$1
outputdir=$2
mkdir -p $outputdir

container_start_regex="^Container: container_.* on .*$"
container_info=""
container_info_flag=0
error_info=""

container_file=""
while IFS= read line
do
 #echo "reading $line"
 if [[ $line =~ $container_start_regex  ]];
 then 
  container=`echo $line | grep -ow "container[a-z0-9_]*"`
  host_id=`echo $line |  cut -d " " -f4`
  container_file=${outputdir}/${container}_${host_id}.log
 fi
[[ ! -z "$container_file" ]] && echo $line>> ${container_file}
done < $file

echo "Done. Check $outputdir"
