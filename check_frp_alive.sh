#!/bin/bash
mypath=$(cd `dirname $0`; pwd)
if ! ps -ef | grep frpc.ini | grep -v $0 | grep -v grep > /dev/null ; then
        $mypath/frpc -c $mypath/frpc.ini 2>&1 > /dev/null &
        echo `date`' frpc was shutdown and restart sucess!' >> $mypath/log.log
fi
