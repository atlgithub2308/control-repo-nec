#!/bin/bash

temp_file="/tmp/temp.$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10; echo '')$(date +%s)"
touch "$temp_file"

awk -F: '($2 == "") { print $1}' /etc/shadow > "$temp_file"

while read -r line; do
    echo "User $line has no password, setting to default..."
    echo -e "$PT_default_password\n$PT_default_password" | (passwd --stdin "$line")
done < <(cat "$temp_file")

rm -f "$temp_file"
