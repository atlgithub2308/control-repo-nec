#!/opt/bin/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

output = `df -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nouser`.split("\n")

$stdout.puts(JSON.generate({ unowned_files_and_dirs: output }))
