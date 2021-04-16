#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

output = {}
users = `$(command -v cut) -d: -f1 /etc/shadow`.split("\n")
users.each do |usr|
  output[usr] = `$(command -v chage) --list #{usr} | grep '^Last password change' | cut -d: -f2`
end

$stdout.puts JSON.generate({ last_pw_change: output })
