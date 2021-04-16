#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

all_gids = `cut -d: -f3 /etc/group`.split("\n")
dup_gids = all_gids.select { |i| all_gids.count(i) > 1 }.uniq
$stdout.puts(JSON.generate({ duplicate_gids: dup_gids }))
