#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

params = JSON.parse(STDIN.read)
basecmd = '$(command -v subscription-manager) register'
cmdargs = []
cmdargs << "--username=#{params['username']}" if params.include?('username')
cmdargs << "--password=#{params['password']}" if params.include?('password')
cmdargs << "--serverurl=#{params['serverurl']}" if params.include?('serverurl')
cmdargs << "--baseurl=#{params['baseurl']}" if params.include?('baseurl')
cmdargs << "--name=#{params['name']}" if params.include?('name')
cmdargs << "--consumerid=#{params['consumerid']}" if params.include?('consumerid')
cmdargs << "--activationkey=#{params['activationkey']}" if params.include?('activationkey')
cmdargs << '--auto-attach' if params.include?('auto_attach') && params['auto_attach']
cmdargs << "--servicelevel=#{params['servicelevel']}" if params.include?('servicelevel')
cmdargs << '--force' if params.include?('force') && params['force']
cmdargs << "--org=#{params['org']}" if params.include?('org')
cmdargs << "--environment=#{params['environment']}" if params.include?('environment')
cmdargs << "--proxy=#{params['proxy']}" if params.include?('proxy')
cmdargs << "--proxyuser=#{params['proxyuser']}" if params.include?('proxyuser')
cmdargs << "--proxypass=#{params['proxypass']}" if params.include?('proxypass')

finalcmd = basecmd.join(cmdargs, ' ')

result = `#{finalcmd}`.strip

$stdout.puts(JSON.generate({ register_result: result }))
