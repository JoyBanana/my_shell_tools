#!/bin/bash

FILELIST=/opt/monitor/log_list.cfg
RESULT=/home/nagios/check_logs_all
#sec*min
QUERY_CIRCAL=$((60*60))
CURRENT_TIMESTAMP=`date '+%s'`

VERSION='3.2'

while [ -n "$1" ]
do
        case "$1" in
                -v) echo "Check logs V$VERSION" && exit 0;;
                *) echo "Option not found : $1" && exit 0;;
        esac
        shift
done


>$RESULT

chown -R nagios.nagios $RESULT

cat $FILELIST | while read i
do
	filepath=`echo $i | awk '{print $1}'`
        head_include="#"
        #check file ignored
        if [[ ! $filepath == $head_include* ]]
        then
                nowTimestamp=`stat -c %Y $filepath`
                check_file_empty=`tail -n 5 $filepath`
                #check log file is empty 
                if [ "$check_file_empty" == '' ]
                then
                        echo "$filepath is empty.\n" >> $RESULT
                else
                        #check timestamp change
			time_c=$(($CURRENT_TIMESTAMP-$nowTimestamp))
                        if [ $time_c -gt $QUERY_CIRCAL ]
                        then
                                echo "$filepath not changed.\n" >> $RESULT
                        fi
                        #check error
                        errorCount=`tail -n 200 $filepath | egrep "Error|Exception" | wc -l`
                        if [ ! $errorCount == 0 ]
                        then
                                echo "error found in $filepath \n" >> $RESULT
                        fi
                fi
        fi
done

if [ "`cat $RESULT`" == ""  ]
then
        echo "Ok"
        exit 0
else
        echo "WARAING `cat $RESULT|paste -s`"
        exit 2
fi
