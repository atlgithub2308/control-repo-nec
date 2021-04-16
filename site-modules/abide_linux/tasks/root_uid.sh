#!/bin/bash

function remove_user {
    echo "Deleting user $i..."
    userdel "$1"
}

function new_user_uid {
    new=$( cat /etc/passwd | cut -d ":" -f 3 | grep -vE "^65[0-9][0-9][0-9]" | sort -n | tail -n 1 | awk '{ print $1+1 }')
    echo "Assigning user $1 UID $new..."
    usermod -u "$new" "$1"
}

function join_by { local IFS="$1"; shift; echo "$*"; }

output=()

for i in $(awk -F: '($3 == 0) { print $1 }' /etc/passwd); do
    if [[ $i != 'root' ]]; then
        case "$PT_duplicate_uid_strategy" in
            remove)
                remove_user "$i"
                output+=("$i")
                ;;
            new_uid)
                new_user_uid "$1"
                output+=("$i")
                ;;
            *)
                output+=("$i")
                ;;
        esac
    fi
done

if [[ ${#output[@]} -gt 0 ]]; then
    if [[ "$PT_duplicate_uid_strategy" -eq 'remove' ]]; then
        echo "{ \"removed_users_with_uid_0\": \"$(join_by , "${output[@]}")\" }"
    elif [[ "$PT_duplicate_uid_strategy" -eq 'new_uid' ]]; then
        echo "{ \"users_with_uid_0_assigned_new_uids\": \"$(join_by , "${output[@]}")\" }"
    else
        echo "{ \"users_with_uid_0\": \"$(join_by , "${output[@]}")\" }"
    fi
else
    echo "{ \"users_with_uid_0\": \"none\" }"
fi