#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

uid_dup_map = {}

all_uids = `cut -d: -f3 /etc/passwd | sort -n`.split("\n")
dup_uids = all_uids.select { |i| all_uids.count(i) > 1 }.uniq

dup_uids.each do |uid|
  uid_dup_map[uid] = `awk -F: '$3 == #{uid}' { print $1 } /etc/passwd`.split("\n")
end

$stdout.puts(JSON.generate(uid_dup_map))
