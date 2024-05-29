#!/bin/sh

deamon="$1"
ppid=0
if [[ ! -z "$2" ]]
then
    ppid="$2"
fi
pid="$(ps -o pid,ppid,comm|grep -E "\s*[0-9]+\s+$ppid+\s+$deamon"|xargs|cut -d ' ' -f 1)"

if [[ -z "$pid" ]] 
then
    exit 1
fi 