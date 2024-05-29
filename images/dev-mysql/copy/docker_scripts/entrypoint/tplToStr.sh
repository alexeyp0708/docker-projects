#!/bin/sh
tpl=$@
if [[ -z "$tpl" ]]
then
    tpl="$(cat)"
fi
defined_envs=$(printf '${%s} ' $(awk "END { for (name in ENVIRON) { print ( name ~ /${filter}/ ) ? name : \"\" } }" < /dev/null ))
#result=$(echo "$tpl"|envsubst "$defined_envs")
#echo "${result}"
echo "$tpl"|envsubst "$defined_envs"