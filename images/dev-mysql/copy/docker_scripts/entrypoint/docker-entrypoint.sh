#!/bin/sh
script_path=$(dirname $(readlink -f "$0"))
source "$script_path/entrypoint-commands.sh"
$script_path/createFromTpl.sh -t /etc/env_tpls -o /etc -i 2;  parent-docker-entrypoint.sh "$@"