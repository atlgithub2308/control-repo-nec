#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

keys = `$(command -v rpm) -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'`.split("\n")
keys.map! { |k| k.split('-->') }
keys_hash = {}
keys.each { |k| keys_hash[k[0]] = k[1] }
$stdout.puts JSON.generate(keys_hash)
