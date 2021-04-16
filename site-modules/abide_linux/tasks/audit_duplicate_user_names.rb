#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

all_un = `cut -d: -f1 /etc/passwd`.split("\n")
dup_un = all_un.select { |i| all_un.count(i) > 1 }.uniq
$stdout.puts(JSON.generate({ duplicate_user_names: dup_un }))
