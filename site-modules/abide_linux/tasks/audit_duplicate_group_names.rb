#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

all_gn = `cut -d: -f1 /etc/group`.split("\n")
dup_gn = all_gn.select { |i| all_gn.count(i) > 1 }.uniq
$stdout.puts(JSON.generate({ duplicate_group_names: dup_gn }))
