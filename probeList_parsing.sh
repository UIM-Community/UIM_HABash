function probeList {
    OUTPUT="$($PU_PATH -u $LOGIN -p $PASSWORD controller probe_list '' '')"
    case "$OUTPUT" in 
        *"$FAILED_PATTERN"* ) rc='0';;
        * ) rc='1';;
    esac
    if [ "${rc}" -eq "1" ]; then 
        local _t=( $(echo "$OUTPUT" | grep -Eo "[a-zA-Z_]+[[:space:]]+PDS_PDS") )
        probeList_arr=()
        for str in "${_t[@]}"; do
            if [ "$str" != "PDS_PDS" ] && [ "$str" != "hub" ] && [ "$str" != "controller" ] && [ "$str" != "hdb" ] && [ "$str" != "spooler" ]; then 
                probeList_arr+=($str)
            fi
        done
    fi
}
