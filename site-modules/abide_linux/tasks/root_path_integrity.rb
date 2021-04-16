#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

EMPTY_DIR = %r{::}.freeze
TRAILING_COLON = %r{:$}.freeze
GROUP_WRITABLE = %r{^\d\d\d[2367]\d$}.freeze

sys_path = `su - root -c 'echo $PATH'`.strip

output = {
  path: sys_path,
  generic_errors: [],
  dir_errors: {},
}

output[:generic_errors].push('Empty Directory in PATH (::)') if EMPTY_DIR.match?(sys_path)
output[:generic_errors].push('Trailing : in PATH') if TRAILING_COLON.match?(sys_path)
sys_path.split(':').each do |item|
  if File.directory?(item)
    if item == '.'
      output[:generic_errors].push('PATH contains current working directory (.)')
    else
      stat = File.stat(item)
      output[:dir_errors][item] = 'Not owned by root' if stat.uid != 0
      output[:dir_errors][item] = 'World writable' if stat.world_writable?
      output[:dir_errors][item] = 'Group writable' if GROUP_WRITABLE.match?('%o' % stat.mode.to_s)
    end
  else
    output[:dir_errors][item] = 'Not a directory'
  end
end

$stdout.puts(JSON.generate(output))
