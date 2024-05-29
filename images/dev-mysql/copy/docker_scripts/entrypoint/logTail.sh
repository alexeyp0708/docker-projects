#!/bin/sh
script_path=$(dirname $(readlink -f "$0"))

runFileTail(){
    #local deamon="$1"
    local log_file="$1"
    #local pid=$(ps -ef |grep -E ".+\s*[0-9]+\s+0+\s+[0-9]+.+\s+.+\s+.+\s$deamon\s*$"|xargs|awk '{print $2}')
    if [[ ! -e "$log_file" ]]
    then
        local dir="$(dirname "$log_file")"
        mkdir -p $dir
        touch $log_file
    fi
    echo "Read log file tail - '$log_file'"
    tail -f "$log_file"
}


runTail(){
    local param=$1
    local conf_file="/etc/my.cnf"
    if [[ ! -z "$2" ]]
    then
        conf_file="$2"
    fi
    local log_file="$(grep "^\s*${param}\s*=" "$conf_file"|cut -d '=' -f 2)"
    if [[ -z "$log_file" ]]
    then
        echo "Error: parameter '$param' is not set in file '$conf_file'" 1>&2
        exit 1
    fi
    log_file="$($script_path/tplToStr.sh $log_file)"
    log_file="$($script_path/tplToStr.sh $log_file)"
    runFileTail "$log_file"
}

runTail $@
