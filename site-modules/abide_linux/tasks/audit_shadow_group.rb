#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

shadow_gid = `grep ^shadow:[^:]*:[^:]*:[^:]+ /etc/group`.strip
users_in_shadow = `awk -F: '($4 == "#{shadow_gid}") { print $1}' /etc/passwd`.split("\n")

$stdout.puts(JSON.generate({ users_in_shadow_group: users_in_shadow }))
