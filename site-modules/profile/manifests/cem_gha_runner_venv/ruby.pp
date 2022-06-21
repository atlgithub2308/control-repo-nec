# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::cem_gha_runner_venv::ruby
class profile::cem_gha_runner_venv::ruby (
  Array[String] $rubygems = [],
) {
  include archive

  package { 'ruby-full':
    ensure          => present,
    provider        => 'apt',
    install_options => ['-y', '--no-install-recommends'],
  }
  $rubygems.each |$gem| {
    package { $gem:
      ensure    => present,
      provider  => 'gem',
      subscribe => Package['ruby-full'],
    }
  }
  include profile::cem_gha_runner_venv::ruby::toolcache
}
