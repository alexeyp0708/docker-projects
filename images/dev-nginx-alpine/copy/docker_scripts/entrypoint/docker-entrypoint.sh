#!/bin/sh
script_path=$(dirname $(readlink -f "$0"))
chown www-data $DC_WORK_DIR
UPSTREAM_LIST="$(echo -e "$UPSTREAM_LIST")"
addUpstream(){
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

setUpstreamList(){
   echo -e "$@"|while read -r host_port
    do
      addUpstream $host_port
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