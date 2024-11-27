#!/bin/sh
script_path=$(dirname $(readlink -f "$0"))
chown www-data $DC_WORK_DIR
UPSTREAM_LIST="$(echo -e "$UPSTREAM_LIST")"
addUpstream(){
    echo $1 
    local host="$(echo $1|cut -d ':' -f 1)"
    local port="$(echo $1|cut -d ':' -f 2)"
    
    #cgi-fcgi -bind -connect $host:$port>/dev/null
    #if [[ "$?" == "0" ]] 
    #then
        cat <<EOF >> /etc/nginx/templates/upstream/upstream.conf.template
upstream $host {
    server $host:$port;
}

EOF
    #fi
}

_deprecated_setUpstreamList(){
    echo -n "" > /etc/nginx/templates/upstream/upstream.conf.template
    echo -e "$@"|while read -r host_port
    do
        if [[ ! -z "$host_port" ]]
        then
          addUpstream $host_port
        fi
    done 
}

setUpstreamList(){
    echo -n "" > /etc/nginx/templates/upstream/upstream.conf.template
    local IFS=';'
    for host_port in $@
    do
        if [[ ! -z "$host_port" ]]
        then
            addUpstream $host_port
        fi
    done
}

setServersConfig(){
    local conf=$@
    if [[ ! -z "$conf" ]]
    then
        echo -e "$conf" > /etc/nginx/templates/conf.d/other.conf.template
    fi
}

mkdir -p ${DC_WORK_DIR}/${HOSTNAME}/log/
setUpstreamList "$UPSTREAM_LIST"
setServersConfig "$SERV_CONFIG"
exec $script_path/parent-docker-entrypoint.sh "$@"