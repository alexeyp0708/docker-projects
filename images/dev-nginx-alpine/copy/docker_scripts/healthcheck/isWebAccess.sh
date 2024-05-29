#!/bin/sh

link=$1
#status=$(curl -I $link 2>/dev/null| head -n 1 | cut -d ' ' -f2)

#if [[ "$status" == "200" ]]
#then
#    exit 0
#else
#    exit 1
#fi;
    
curl -f $link >/dev/null 2>&1  || exit 1