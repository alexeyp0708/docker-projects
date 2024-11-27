#!/bin/bash
services=$@
export NGINX_UPSTREAM_LIST=
if [[ -z "$services" ]]
then
    services="mysql php83 nginx ftp"
fi
fn_exists(){ 
    declare -F "$1" > /dev/null; 
}
initServices(){ 
    for service in $@
    do
        fn_exists init_$service && init_$service
    done
}

init_php83() {
    export NGINX_UPSTREAM_LIST=$(echo "$NGINX_UPSTREAM_LIST;php83:9000")
}
initServices $services
docker compose up --build $@
