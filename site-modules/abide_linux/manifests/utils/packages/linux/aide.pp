# @summary This class installs and configures AIDE
#
# This class installs AIDE and can create a systemd
# timer service for AIDE to run scheduled checks.
#
# @param [Optional[Boolean]] control_package
#   Whether or not to ensure the package is installed.
#   Default: true
#
# @param [Optional[String]] package_ensure
#   Passed directly to the package resource for aide.
#   Default: installed
#
# @param [Optional[Boolean]] manage_config
#   Whether or not to manage /etc/aide.conf.
#   Default: true
#
# @param [Optional[Boolean]] conf_purge
#   Setting purge to true means that no default values will be used.
#   WARNING: You MUST configure ALL CONFIG OPTIONS when using purge
#   to ensure that AIDE can function.
#   Default: false
#
# @param [Optional[Boolean]] run_scheduled
#   Whether or not to set AIDE to run on a schedule.
#   Default: true
#
# @param [Optional[Enum[systemd, cron]]] scheduler
#   Whether to use a systemd timer or cron job to schedule
#   AIDE scans.
#   Default: systemd
#
# @param [Optional[String]] systemd_timer_schedule
#   Used as the systemd timer unit file's OnSchedule directive.
#   Default: '*-*-* 00:00:00'
#
# @param [Optional[String]] conf_source
#   Passed directly into a file resource to create the config file.
#   Default: undef
#
# @param [Optional[String]] conf_db_dir
#   The directory AIDE will use to store the DB.
#   Default: /var/lib/aide
#
# @param [Optional[String]] conf_log_dir
#   The directory AIDE will use to store the log file.
#   Default: /var/log/aide
#
# @param [Optional[Integer]] conf_verbosity
#   How verbose AIDE is in logging. Default: 5
#
# @param [Optional[Array[String]]] conf_report_urls
#   Where AIDE should send check results.
#   Default: [ 'file:@@{LOGDIR}/aide.log', 'stdout' ]
#
# @param [Optional[Array[String]]] conf_rules
#   Custom rule definitions for the AIDE config file. Each item is
#   passed into the config as is, so rule definitions should look
#   like: "PERMS = p+u+g+acl+selinux+xattrs". See docs for defaults.
#
# @param [Optional[Array[String]]] conf_checks
#   Directory and file checks. As AIDE parses these from top to
#   bottom in the config file, the way you order this array matters.
#   Individual file checks should come before their parent directory
#   checks. Each check is passed into the config as is, so checks
#   should look like: "/boot/ CONTENT_EX". See docs for defaults.
#   If you choose not to use the default values, it is HIGHLY 
#   RECOMMENDED that you ignore the directory /opt/puppetlabs/puppet/cache/
#   and ignore the file /opt/puppetlabs/puppet/public/last_run_summary.yaml
#   as these change every Puppet run.
#
# @example
#   include abide_linux::utils::packages::linux::aide
class abide_linux::utils::packages::linux::aide (
  Optional[Boolean] $control_package = undef,
  Optional[String] $package_ensure = undef,
  Optional[Boolean] $manage_config = undef,
  Optional[Boolean] $conf_purge = undef,
  Optional[Boolean] $run_scheduled = undef,
  Optional[Enum['systemd', 'cron']] $scheduler = undef,
  Optional[String] $systemd_timer_schedule = undef,
  Optional[String] $conf_source = undef,
  Optional[String] $conf_db_dir = undef,
  Optional[String] $conf_log_dir = undef,
  Optional[Integer] $conf_verbosity = undef,
  Optional[Array[String]] $conf_report_urls = undef,
  Optional[Array[String]] $conf_rules = undef,
  Optional[Array[String]] $conf_checks = undef,
) {
  # $defaults shouldn't be overridden, so no automatic lookup
  # We keep the Hiera key name close to the autobind name for ease of use
  # This may seem insane, but due to how we propagate the params down
  # from abide, we will be receving undef values explicitly as params.
  # This way, we still provide defaults.
  $defaults = lookup('abide_linux::utils::packages::linux::aide::defaults')

  $_control_package = $control_package ? {
    undef => $defaults['control_package'],
    default => $control_package,
  }
  $_package_ensure = $package_ensure ? {
    undef => $defaults['package_ensure'],
    default => $package_ensure,
  }
  $_manage_config = $manage_config ? {
    undef => $defaults['manage_config'],
    default => $manage_config,
  }
  $_conf_purge = $conf_purge ? {
    undef => $defaults['conf_purge'],
    default => $conf_purge,
  }
  $_run_scheduled = $run_scheduled ? {
    undef => $defaults['run_scheduled'],
    default => $run_scheduled,
  }
  $_scheduler = $scheduler ? {
    undef => $defaults['scheduler'],
    default => $scheduler,
  }
  $_systemd_timer_schedule = $systemd_timer_schedule ? {
    undef => $defaults['systemd_timer_schedule'],
    default => $systemd_timer_schedule,
  }
  $_conf_source = $conf_source ? {
    undef => undef,
    default => $conf_source,
  }
  # If conf_purge is set, we don't use ANY defaults.
  if $_conf_purge {
    $_options = {
      'db_dir' => $conf_db_dir,
      'log_dir' => $conf_log_dir,
      'verbosity' => $conf_verbosity,
      'report_urls' => $conf_report_urls,
      'rules' => $conf_rules,
      'checks' => $conf_checks,
    }
  } else {
    $_db_dir = $conf_db_dir ? {
      undef => $defaults['conf_db_dir'],
      default => $conf_db_dir,
    }
    $_log_dir = $conf_log_dir ? {
      undef => $defaults['conf_log_dir'],
      default => $conf_log_dir,
    }
    $_verbosity = $conf_verbosity ? {
      undef => $defaults['conf_verbosity'],
      default => $conf_verbosity,
    }
    $_report_urls = $conf_report_urls ? {
      undef => $defaults['conf_report_urls'],
      default => $conf_report_urls,
    }
    $_rules = $conf_rules ? {
      undef => $defaults['conf_rules'],
      default => $conf_rules,
    }
    $_checks = $conf_checks ? {
      undef => $defaults['conf_checks'],
      default => $conf_checks,
    }
    $_options = {
      'db_dir' => $_db_dir,
      'log_dir' => $_log_dir,
      'verbosity' => $_verbosity,
      'report_urls' => $_report_urls,
      'rules' => $_rules,
      'checks' => $_checks,
    }
  }

  if $facts['kernel'] == 'Linux' {
    if $_control_package {
      class { 'abide_linux::utils::packages::linux::aide::package':
        package_ensure => $_package_ensure,
        db_dir         => $_db_dir,
        before         => Class['abide_linux::utils::packages::linux::aide::config'],
      }
    }
    if $_manage_config {
      class { 'abide_linux::utils::packages::linux::aide::config':
        source  => $_conf_source,
        options => $_options,
        before  => Class['abide_linux::utils::packages::linux::aide::service'],
      }
    }
    if $_run_scheduled {
      case $_scheduler {
        'systemd': {
          class { 'abide_linux::utils::packages::linux::aide::service':
            timer_schedule          => $_systemd_timer_schedule,
            systemd_service_content => $defaults['systemd_service_content'],
          }
        }
        default: {
          warning("Scheduler ${_scheduler} is not implemented yet!")
        }
      }
    }
  }
}
