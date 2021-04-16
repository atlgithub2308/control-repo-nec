#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

passwd_groups = `cut -s -d: -f4 /etc/passwd | sort -u`.split("\n")
group_name_guid = `cut -s -d: -f3 /etc/group | sort -u`.split("\n")
missing_passwd_groups = passwd_groups - group_name_guid

$stdout.puts(JSON.generate({ nonexistent_passwd_groups: missing_passwd_groups }))
