#!/bin/bash

filelist=/opt/monitor/log_list.cfg
RESULT=/home/nagios/check_logs_all
VERSION='3.0'

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

cat $filelist | while read i
do
        filepath=`echo $i | awk '{print $1}'`
        timestamp=`echo $i | awk '{print $2}'`

        B="#"
        #shi fou zhu shi diao le
        if [[ ! $filepath == $B* ]]
        then
                newTimestamp=`stat -c %Y $filepath`
                check_file_empty=`tail -n 5 $filepath`

                #check log file isempty 
                if [ "$check_file_empty" == '' ]
                then
                        echo "$filepath is empty.\n" >> $RESULT
                else
                        #check timestamp changes
                        if [ $newTimestamp == $timestamp ]
                        then
                                echo "$filepath does not changed for a while.\n" >> $RESULT
                        else
                                filepath_Escape=${filepath//\//\\\/}
                                sed -i "s/$filepath_Escape[[:space:]]$timestamp/$filepath_Escape\ $newTimestamp/g" $filelist
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
