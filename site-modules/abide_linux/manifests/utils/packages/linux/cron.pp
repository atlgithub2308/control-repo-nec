# @summary Configures permissions and allowlist for cron
#
# Configures permissions for crontab and cron directories,
# as well as configures an allowlist for cron.
#
# @param [Optional[Boolean]] manage_package
#   If true, ensures the `cronie` package is installed.
#   Default: true
# @param [Optional[Boolean]] manage_service
#   If true, enables and runs the `crond` daemon with a service resource.
#   Default: true
# @param [Optional[Boolean]] set_crontab_perms
#   If true, enforces `0600` permissions on /etc/crontab.
#   Default: true
# @param [Optional[Boolean]] set_hourly_cron_perms
#   If true, enforces `0700` permissions on /etc/cron.hourly.
#   Default: true
# @param [Optional[Boolean]] set_daily_cron_perms
#   If true, enforces `0700` permissions on /etc/cron.daily.
#   Default: true
# @param [Optional[Boolean]] set_weekly_cron_perms
#   If true, enforces `0700` permissions on /etc/cron.weekly.
#   Default: true
# @param [Optional[Boolean]] set_monthly_cron_perms
#   If true, enforces `0700` permissions on /etc/cron.monthly.
#   Default: true
# @param [Optional[Boolean]] set_cron_d_perms
#   If true, enforces `0700` permissions on /etc/cron.d.
#   Default: true
# @param [Optional[Boolean]] purge_cron_deny
#   If true, removes (if they exist) /etc/cron.deny and /etc/cron.d/cron.deny.
#   Default: true
# @param [Optional[Boolean]] manage_cron_allow
#   If true, creates the cron.allow file specified by the `cron_allow_path`
#   parameter and enforces `0600` permissions on the file.
#   Default: true
# @param [Optional[Stdlib::AbsolutePath]] cron_allow_path
#   The path for the cron.allow file to manage. Only relevant if `set_cron_allow_perms`
#   is set to `true`.
#   Default: /etc/cron.allow
# @param [Optional[Array[String[1]]]] cron_allowlist
#   An array of user names to add to the cron.allow file.
#   Default: [root]
#
# @example
#   include abide_linux::utils::packages::linux::cron
class abide_linux::utils::packages::linux::cron (
  Optional[Boolean] $manage_package = undef,
  Optional[Boolean] $manage_service = undef,
  Optional[Boolean] $set_crontab_perms = undef,
  Optional[Boolean] $set_hourly_cron_perms = undef,
  Optional[Boolean] $set_daily_cron_perms = undef,
  Optional[Boolean] $set_weekly_cron_perms = undef,
  Optional[Boolean] $set_monthly_cron_perms = undef,
  Optional[Boolean] $set_cron_d_perms = undef,
  Optional[Boolean] $purge_cron_deny = undef,
  Optional[Boolean] $manage_cron_allow = undef,
  Optional[Stdlib::AbsolutePath] $cron_allow_path = undef,
  Optional[Array[String[1]]] $cron_allowlist = undef,
) {
  include stdlib

  $_manage_package = undef_default($manage_package, true)
  $_manage_service = undef_default($manage_service, true)
  $_set_crontab_perms = undef_default($set_crontab_perms, true)
  $_set_hourly_cron_perms = undef_default($set_hourly_cron_perms, true)
  $_set_daily_cron_perms = undef_default($set_daily_cron_perms, true)
  $_set_weekly_cron_perms = undef_default($set_weekly_cron_perms, true)
  $_set_monthly_cron_perms = undef_default($set_monthly_cron_perms, true)
  $_set_cron_d_perms = undef_default($set_cron_d_perms, true)
  $_purge_cron_deny = undef_default($purge_cron_deny, true)
  $_manage_cron_allow = undef_default($manage_cron_allow, true)
  $_cron_allow_path = undef_default($cron_allow_path, '/etc/cron.d/cron.allow')
  $_cron_allowlist = undef_default($cron_allowlist, ['root'])

  if $_manage_package {
    package { 'abide_cronie':
      ensure => present,
      name   => 'cronie',
    }
  }

  if $_manage_service {
    service { 'abide_cron_service':
      ensure => running,
      name   => 'crond',
      enable => true,
    }
    if $_manage_package {
      Service['abide_cron_service'] {
        require => Package['abide_cronie'],
      }
    }
  }
  if $_manage_package {
    File {
      owner => 'root',
      group => 'root',
      require => Package['abide_cronie'],
    }
  } else {
    File {
      owner => 'root',
      group => 'root',
    }
  }
  if $_set_crontab_perms {
    file { 'abide_crontab_perms':
      ensure => file,
      path   => '/etc/crontab',
      mode   => '0600',
    }
  }
  if $_set_hourly_cron_perms {
    file { 'abide_hourly_cron_perms':
      ensure => directory,
      path   => '/etc/cron.hourly',
      mode   => '0700',
    }
  }
  if $_set_daily_cron_perms {
    file { 'abide_daily_cron_perms':
      ensure => directory,
      path   => '/etc/cron.daily',
      mode   => '0700',
    }
  }
  if $_set_weekly_cron_perms {
    file { 'abide_weekly_cron_perms':
      ensure => directory,
      path   => '/etc/cron.weekly',
      mode   => '0700',
    }
  }
  if $_set_monthly_cron_perms {
    file { 'abide_monthly_cron_perms':
      ensure => directory,
      path   => '/etc/cron.monthly',
      mode   => '0700',
    }
  }
  if $_set_cron_d_perms {
    file { 'abide_cron_d_perms':
      ensure => directory,
      path   => '/etc/cron.d',
      mode   => '0700',
    }
  }
  if $_purge_cron_deny {
    file { 'abide_purge_etc_cron_deny':
      ensure => absent,
      path   => '/etc/cron.deny',
    }
    file { 'abide_purge_etc_crond_cron_deny':
      ensure => absent,
      path   => '/etc/cron.d/cron.deny',
    }
  }
  if $_manage_cron_allow {
    file { 'abide_cron_allow_perms':
      ensure  => file,
      path    => $_cron_allow_path,
      mode    => '0600',
      content => epp('abide_linux/config/cron_at.allow.epp', { users => $_cron_allowlist }),
      require => File['/etc/cron.d'],
    }
  }
}
