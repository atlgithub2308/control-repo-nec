#!/bin/bash

set -x

unsticky=()

function check {
    df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null
}

function check_sticky {
    unset unsticky
    IFS=$'\n' read -r -d '' -a unsticky < <( check && printf '\0' )
    len=${#unsticky[@]}
    if [ "${len}" -gt 0 ]; then
        exit 0
    else
        exit 1
    fi
}

function set_sticky {
    unset unsticky
    IFS=$'\n' read -r -d '' -a unsticky < <( check && printf '\0' )
    len=${#unsticky[@]}
    if [ "${len}" -gt 0 ]; then
        for i in "${unsticky[@]}"; do
            chmod a+t "${i}"
        done
    else
        exit 0
    fi
}

while getopts 'cs' opt; do
    case ${opt} in
        c) check_sticky
           ;;
        s) set_sticky
           ;;
        *) echo "Invalid flag: ${opt}"
           exit 1
           ;;
    esac
done
