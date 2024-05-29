_get_option(){
    local reg_opt="$1"
    shift
    echo "$@" | grep -o -E "$reg_opt" | tail -n 1 | cut -d '=' -f 2 
}
mysql_get_user_option() {
    local reg_opt="\s--user=[a-zA-z0..9_\-]+"
    local proc_user="$(_get_option "$reg_opt" $@)"
    if [[ -z "$proc_user" ]]
    then
        local no_defaults="$(echo "$@"|grep -o -E "\s--no-defaults")"
        local defaults_file="$(echo "$@"|grep -o -P '\s--defaults-file\s*=\s*(?:[\S]+|"[\s\S]+?"|'[\s\S]+?')'|tail -n 1)"
        local defaults_extra_file="$(echo "$@"|grep -o -P '\s--defaults-extra-file\s*=\s*(?:[\S]+|"[\s\S]+?"|'[\s\S]+?')')"
        if [[ -z "$no_defaults" ]]
        then
            proc_user="$(_get_option "$reg_opt" $(mysqld $defaults_file $defaults_extra_file --print-defaults))"
        fi
    fi
    echo "$proc_user"
}

mysql_get_user_option $@