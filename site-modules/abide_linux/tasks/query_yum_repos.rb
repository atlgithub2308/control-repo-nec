#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'

def format_repo_array(repo)
  ary = repo.split('  ')
  ary.delete_if(&:empty?)
  ary.map(&:strip)
end

raw_repolist = `$(command -v yum) repolist -q`.split("\n")
repos = raw_repolist[1..-1]
repos.map! { |r| format_repo_array(r) }

out_repos = []
repos.each do |r|
  out_repos << { id: r[0], name: r[1], status: r[2] }
end

$stdout.puts JSON.generate({ repolist: out_repos })
