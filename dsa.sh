#!/bin/bash

df -h ./;

#####################################

process_fun_downd() {
    local fund_str="$1"
    local fund=$(echo "$fund_str" | awk '{print $2}')  
    local line_num=0
    local found=0
    local funprev=""
    local funpast=""
    local current_line
    while IFS= read -r current_line; do
        line_num=$((line_num + 1))
        fun_path=$(echo "$current_line" | awk '{print $2}')
        if [[ -z "$current_line" ]]; then
            continue
        fi
        if [[ -z "$fun_path" ]]; then
            fun_path="$current_line"
        fi
        if [[ -z "$fun_path" ]]; then
            continue
        fi
        if [[ "$fun_path" == "$fund"* && $found -eq 0 ]]; then
            found=1
            break
        fi
    done <<< "$fun"

    if [[ $found -eq 1 ]]; then
        funprev=$(echo "$fun" | head -n "$((line_num - 1))")
        funpast=$(echo "$fun" | tail -n +"$line_num" | head -n -1)
        fun=$(printf "%s\n%s\n%s\n" "$funprev" "$fund_str" "$funpast")
    else
        fun=$(printf "%s\n%s\n" "$fun" "$fund_str")
    fi
}

funny_sort() {
local first=""
local fun=""
    while IFS= read -r line; do
        first=$(echo -e "${first}\n${line}");
    done
    first=$(echo "${first}" | tail -n+2)
    fnext="${first}"
while [ -n "${first}" ]; do
    fline=$(echo "$first" | head -1)
    fun=$(echo -e "${fun}\n${fline} ")
    fpath=$(echo "$fline"|column -H 1 -t)
    if [[ "${fpath}" != "$(pwd)" && "${fpath}" != "/" && "${fpath}" != "" ]];then
        downd=$(echo "${first}" | grep -F "${fpath}")
        while IFS= read -r downd_line; do
            if [[ "${downd_line}" != "" ]]; then
                process_fun_downd "$downd_line"
            fi
        done <<< "$downd"


        first=$(echo "${first}" | grep -v -F "${fpath}")
    fi
    if [[ "$(echo ${downd} | wc -l)" -gt "0" && -z "${downd}" ]]; then
        first=$(echo "${first}" | tail -n+2)
    fi
done

echo -e "${fun}"

}
read_input() {
    local prompt="$1"
    local default="$2"
    local result
    if [ -t 1 ]; then
        read -p "$prompt" result
    else
        read -p "$prompt" result < /dev/tty
    fi
    echo "${result:-$default}"
}

minsize=$(read_input "Enter minimal size NUM(k|m|g) [250m]: " "250m")

case "$minsize" in
    *[kK]) minsize=$(echo "$minsize" | sed 's/[kK]/K/') ;;
    *[mM]) minsize=$(echo "$minsize" | sed 's/[mM]/M/') ;;
    *[gG]) minsize=$(echo "$minsize" | sed 's/[gG]/G/') ;;
    *[0-9]) minsize="${minsize}M" ;;
    *) echo "Invalid size format." && exit 1 ;;
esac

maxdepth=$(read_input "Enter max depth [7]: " "7")

if ! [[ "$maxdepth" =~ ^[0-9]+$ ]]; then
    echo "Invalid max depth format."
    exit 1
fi
if [[ "$(pwd)" == "/" ]]; then
    fpwd=""
else 
    fpwd="$(pwd)"
fi

echo "Disk usage report:"

stdbuf -oL du -ahxP --max-depth=$maxdepth --exclude=/dev --exclude=/proc -P "$(pwd)" | \
    stdbuf -oL grep -E "^[0-9\.,]+[KMG]" | \
    stdbuf -oL awk -v minsize="$minsize" '
    BEGIN {
        unit = substr(minsize, length(minsize), 1)
        size = substr(minsize, 1, length(minsize)-1)
        if (unit == "K") { min_bytes = size * 1024 }
        else if (unit == "M") { min_bytes = size * 1024 * 1024 }
        else if (unit == "G") { min_bytes = size * 1024 * 1024 * 1024 }
        else { min_bytes = size }
    }
    function convert_to_bytes(val, unit) {
        if (unit == "K") { return val * 1024 }
        else if (unit == "M") { return val * 1024 * 1024 }
        else if (unit == "G") { return val * 1024 * 1024 * 1024 }
        else { return val }
    }
    {
        val = $1
        size_unit = substr(val, length(val))
        size_val = substr(val, 1, length(val)-1)
        bytes = convert_to_bytes(size_val, size_unit)
        if (bytes >= min_bytes) {
            print $0
        }
    }' | tee >(while read -r line; do
    max_length=18
    current_length=0
    direction=1
    while read -r line; do
            printf "\r%*s" $current_length | tr " " "."
            current_length=$((current_length + direction))
            if [ $current_length -ge $max_length ]; then
                direction=-1
            fi
            if [ $current_length -le 1 ]; then
                direction=1
            fi
            sleep 0.1
        done 
    done >&2) | sort  -hr -k1,1 -k2,2 | funny_sort | sed -E "s#^([^/]{1,12}${fpwd}/[^/]+$)#\n\1#g"
