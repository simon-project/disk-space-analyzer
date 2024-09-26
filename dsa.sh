#!/bin/bash

df -h ./;
# removed
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

echo -e "\nDisk usage report:\n"

curdir=$(du --si --max-depth=1 --exclude=/proc $(pwd)| sort -hr)
echo "${curdir}" | head -1
echo ""
echo "${curdir}" |awk '{for (i=2; i<=NF; i++) printf "%s%s", $i, (i<NF ? OFS : ORS)}' | tail -n+2 | while read -r i; do 
    du -xh --max-depth=$maxdepth --exclude=/proc -P "${i}" | \
    grep -E "^[0-9\.,]+[KMG]" | \
    awk -v minsize="$minsize" '
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
    }' | sort -hr
echo -e "\n"
done | sed -E ':a;N;$!ba;s/\n{3,}/\n\n/g'
