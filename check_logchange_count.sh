#!/bin/bash
COUNT=5
LOGPATH=/root/log.log
RESTART_SRC=/root/restart.sh
QUERY_CIRCAL=$((60*10))
VERSION='1.0'

#check log change and restart process
#while :
#do
CURRENT_TIMESTAMP=`date '+%s'`
count=`awk 'NR==2{print}' $0`
count=${count#*=}
countAdd(){
sed -i "s/COUNT=$count/COUNT=$(($count+1))/g" $0
$RESTART_SRC
}

fileTimestamp=`stat -c %Y $LOGPATH`
check_file_empty=`tail -n 5 $LOGPATH`
#check log file is empty 
if [ "$check_file_empty" == '' ]
then
	echo "$LOGPATH is empty."
	countAdd
else
	#check timestamp change
	time_c=$(($CURRENT_TIMESTAMP-$fileTimestamp))
	if [ $time_c -gt $QUERY_CIRCAL ]
	then
		echo "$LOGPATH not changed."
		countAdd
	fi
fi
sleep 2s
#done
