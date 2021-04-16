#!/opt/bin/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

ipv4_listeners = `$(command -v ss) -Hnl4p | awk '{print $1,$2,$5,$6,$7}'`.split("\n")
ipv6_listeners = `$(command -v ss) -Hnl6p | awk '{print $1,$2,$5,$6,$7}'`.split("\n")
ipv4_listeners.map!(&:split)
ipv6_listeners.map!(&:split)

ipv4_res = []
ipv4_listeners.each do |i|
  ipv4_res << {
    proto: i[0],
    state: i[1],
    local: i[2],
    peer: i[3],
    proc_name: %r{users:\(\("(.*)"\)\)}.match(i[4])[1],
    pid: %r{pid=([0-9]+)}.match(i[4])[1],
  }
end
ipv6_res = []
ipv6_listeners.each do |i|
  ipv6_res << {
    proto: i[0],
    state: i[1],
    local: i[2],
    peer: i[3],
    proc_name: %r{users:\(\("(.*)"\)\)}.match(i[4])[1],
    pid: %r{pid=([0-9]+)}.match(i[4])[1],
  }
end

$stdout.puts(JSON.generate({ ipv4_listeners: ipv4_res, ipv6_listeners: ipv6_res }))
