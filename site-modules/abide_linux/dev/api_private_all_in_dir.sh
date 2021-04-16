#!/bin/bash

# This script adds "# @api private" to the first line of all
# files in the given directory.

for filename in $1/*.pp; do
	if [ "$(head -1 $filename)" != '# @api private' ]; then
		sed -i '' '1i\
	            \# @api private
		' ${filename}
	fi
done
