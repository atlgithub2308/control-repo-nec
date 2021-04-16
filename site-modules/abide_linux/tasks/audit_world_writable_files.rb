#!/opt/bin/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

output = `df -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002`.split("\n")

$stdout.puts(JSON.generate({ world_writable_files: output }))
