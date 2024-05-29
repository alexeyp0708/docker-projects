#!/bin/bash
command=$1
if [[ $# -eq 0 || $command != "start" && $command != "stop" && $command != "restart" && $command != "status" && $command != "logs" ]]
then
    echo "Enter commands => start|stop|restart|status|logs [(default)all | (\$1..\$8)version_args]"
    echo "Example: phpService.sh status 7.4 8.3"
    echo "Example: phpService.sh status all"
    echo "Example: phpService.sh status"
    exit;
fi

status=$2
declare -a versions
declare -a commands
if [[ $status = "" ]]
then 
 status="all"
fi

if [[ $status = "all" ]]
then 
    echo  "Versions are determined by the presence of corresponding directories in \"/etc/php/\""
    versions=( $(ls '/etc/php/'|grep -P '^\d+\..') )
    echo  "Availability of PHP versions  => ${versions[@]}" 
else 
    shift
    while [ -n "$1" ]
    do
        versions+=($1)
        shift
    done
fi

if [[ $command = "restart" ]]
then
   commands+=("stop")
   commands+=("start")

else 
    commands+=($command)
  
fi 

for ((a=0; a<${#versions[@]}; a++))
do
    cmd=${commands[$a]}
    for ((i=0; i<${#versions[@]}; i++))
    do
        q=${versions[$i]//./}
        #Change this setting if the template does not match
        #Warn: sock_sufix must match the settings in /etc/php/{version}/fpm/pool.d/www.conf, where  seted derictive "listen = /run/php/php{sock_sufix}-fpm.sock" 
        sock_sufix=$q
        pid="$(ps -lA |grep php-fpm${versions[$i]}|awk {'print $4" "$5'}|grep '\s1$'|awk {'print $1'})"
        if [[ $cmd = "status" ]] 
        then
            if [[ $pid != "" ]] 
            then 
                echo "Service php-fpm${versions[$i]} runned. PID=>$pid"
            else
                echo "Service php-fpm${versions[$i]} stoped."
            fi
        elif [[ $cmd = "start" ]]
        then 
            if [[ $pid = "" ]]
            then 
                echo "start => /usr/sbin/php-fpm${versions[$i]} --fpm-config /etc/php/${versions[$i]}/fpm/php-fpm.conf && /usr/lib/php/php-fpm-socket-helper install /run/php/php$sock_sufix-fpm.sock /etc/php/${versions[$i]}/fpm/pool.d/www.conf $q"
                /usr/sbin/php-fpm${versions[$i]} --fpm-config /etc/php/${versions[$i]}/fpm/php-fpm.conf && /usr/lib/php/php-fpm-socket-helper install /run/php/php$sock_sufix-fpm.sock /etc/php/${versions[$i]}/fpm/pool.d/www.conf $q
                 pid="$(ps -lA |grep php-fpm${versions[$i]}|awk {'print $4" "$5'}|grep '\s1$'|awk {'print $1'})"
                 echo "Service php-fpm${versions[$i]} runned. PID=>$pid"
            else 
                echo "The service php-fpm${versions[$i]} is already running. PID=>$pid"
            fi
        elif [[ $cmd = "stop" ]]
        then
            if [[ $pid != "" ]]
            then 
                echo "stop => kill $pid && /usr/lib/php/php-fpm-socket-helper remove /run/php/php${sock_sufix}-fpm.sock /etc/php/${versions[$i]}/fpm/pool.d/www.conf $q"
                kill $pid && /usr/lib/php/php-fpm-socket-helper remove /run/php/php${sock_sufix}-fpm.sock /etc/php/${versions[$i]}/fpm/pool.d/www.conf $q
                for (( s=0; s<10; s++ ))
                do
                    if [[ -z "$(ps $pid|grep $pid)" ]]
                    then
                        break
                    fi
                    sleep 1
                done
                if [[ -z "$(ps $pid|grep $pid)" ]]
                then
                    echo "Service php-fpm${versions[$i]} stoped."
                else
                    echo "Warning: Service php-fpm${versions[$i]} did not stop for 10 seconds."
                fi
            fi
        elif [[ $cmd = "logs" ]]
        then
            logs_files=()
            #fpm log
            logs_files+=($(cat /etc/php/${versions[$i]}/fpm/php-fpm.conf|grep '^[^;]'|grep '^error_log\s*='|sed -E 's/^.+=\s*//'|envsubst))
            #php error logs
            logs_files+=($(php-fpm${versions[$i]} -i |grep '^error_log '|awk {'print $5'}))
            
            for ((b=0; b<${#logs_files[@]}; b++))
            do
            flogs="${logs_files[$b]}"
            if [[ $flogs != "" ]]
                then
                    echo -e "\nlogs---------------------------------"
                    echo "Last 50 lines log file => $flogs"
                    echo -e "logs---------------------------------\n"
                    tail -n 50 $flogs
                    echo -e "\nlogs---------------------------------"
                    echo "End log file => $flogs"
                    echo -e "logs---------------------------------\n"
                    read -p "Press any key to resume ..." 
                fi
            done
        fi
    done
done  
if [[ $command = "status" ]]
then 
    if [[ $status = "all" ]]
    then 
        ps -lA |grep -P "(PID|php-fpm)"
    else
        IFS='|'
        ps -lA |grep -P "(PID|php-fpm(${versions[*]}))"
    fi
fi  

