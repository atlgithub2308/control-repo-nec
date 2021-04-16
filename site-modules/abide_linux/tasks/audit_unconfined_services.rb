#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

$stdout.puts(JSON.generate({ unconfined_services: `ps -eZ | grep unconfined_service_t`.split("\n") }))
