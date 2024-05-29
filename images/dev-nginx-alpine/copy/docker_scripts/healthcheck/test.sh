#!/bin/sh
script_path=$(dirname $(readlink -f "$0"))
$script_path/isRun.sh nginx && $script_path/isWebAccess.sh localhost