# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::cem_gha_runner_venv::apt
class profile::cem_gha_runner_venv::apt(
  Array[String] $packages = [],
) {
  service { 'apt-daily.timer':
    ensure => stopped,
    enable => false,
  }
  ~> service { 'apt-daily.service':
    ensure => stopped,
    enable => false,
  }
  service { 'apt-daily-upgrade.timer':
    ensure => stopped,
    enable => false,
  }
  ~> service { 'apt-daily-upgrade.service':
    ensure => stopped,
    enable => false,
  }
  file { '/etc/apt/apt.conf.d/10-apt-autoremove':
    ensure => file,
    source => 'puppet:///modules/profile/cem_gha_runner_venv/apt/10-apt-autoremove',
  }
  -> file { '/etc/apt/apt.conf.d/10-dpkg_options':
    ensure => file,
    source => 'puppet:///modules/profile/cem_gha_runner_venv/apt/10-dpkg_options',
  }
  -> file { '/etc/apt/apt.conf.d/80-retries':
    ensure => file,
    source => 'puppet:///modules/profile/cem_gha_runner_venv/apt/80-retries',
  }
  -> file { '/etc/apt/apt.conf.d/90-assume_yes':
    ensure => file,
    source => 'puppet:///modules/profile/cem_gha_runner_venv/apt/90-assume_yes',
  }
  -> file { '/etc/apt/apt.conf.d/99-bad_proxy':
    ensure => file,
    source => 'puppet:///modules/profile/cem_gha_runner_venv/apt/99-bad_proxy',
  }
  package { 'unattended-upgrades':
    ensure => purged,
  }
  $packages.each |$pkg| {
    package { $pkg:
      ensure          => present,
      provider        => 'apt',
      install_options => ['-y', '--no-install-recommends'],
      require         => File['/etc/apt/apt.conf.d/99-bad_proxy'],
    }
  }
}
