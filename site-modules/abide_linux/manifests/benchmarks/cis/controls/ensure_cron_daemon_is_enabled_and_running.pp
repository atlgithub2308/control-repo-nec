# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] manage_package
# @option config [Boolean] manage_service
# @option config [Boolean] set_crontab_perms
# @option config [Boolean] set_hourly_cron_perms
# @option config [Boolean] set_daily_cron_perms
# @option config [Boolean] set_weekly_cron_perms
# @option config [Boolean] set_monthly_cron_perms
# @option config [Boolean] set_cron_d_perms
# @option config [Boolean] purge_cron_deny
# @option config [Boolean] set_cron_allow_perms
# @option config [Stdlib::AbsolutePath] cron_allow_path
# @option config [Array[String[1]]] cron_allowlist
#
# @see abide_linux::utils::packages::linux::cron
class abide_linux::benchmarks::cis::controls::ensure_cron_daemon_is_enabled_and_running (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::packages::linux::cron':
    manage_package         => dig($config, 'manage_package'),
    manage_service         => dig($config, 'manage_service'),
    set_crontab_perms      => dig($config, 'set_crontab_perms'),
    set_hourly_cron_perms  => dig($config, 'set_hourly_cron_perms'),
    set_daily_cron_perms   => dig($config, 'set_daily_cron_perms'),
    set_weekly_cron_perms  => dig($config, 'set_weekly_cron_perms'),
    set_monthly_cron_perms => dig($config, 'set_monthly_cron_perms'),
    set_cron_d_perms       => dig($config, 'set_cron_d_perms'),
    purge_cron_deny        => dig($config, 'purge_cron_deny'),
    manage_cron_allow      => dig($config, 'set_cron_allow_perms'),
    cron_allow_path        => dig($config, 'cron_allow_path'),
    cron_allowlist         => dig($config, 'cron_allowlist'),
  }
}
