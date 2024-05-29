#!/bin/sh
script_path=$(dirname $(readlink -f "$0"))
conf_file="/etc/my.cnf"
if [[ ! -z "$2" ]]
then
    conf_file="$2"
fi
echo "$(grep "^\s*$1\s*=" "$conf_file"|cut -d '=' -f 2)"