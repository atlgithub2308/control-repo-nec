# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] control_package
# @option config [String] package_ensure
# @option config [Boolean] manage_config
# @option config [Boolean] conf_purge
# @option config [Boolean] run_scheduled
# @option config [Enum[systemd, cron]] scheduler
# @option config [String] systemd_timer_schedule
# @option config [String] conf_source
# @option config [String] conf_db_dir
# @option config [String] conf_log_dir
# @option config [Integer] conf_verbosity
# @option config [Array[String]] conf_report_urls
# @option config [Array[String]] conf_rules
# @option config [Array[String]] conf_checks
#
# @see abide_linux::utils::packages::linux::aide
class abide_linux::benchmarks::cis::controls::ensure_aide_is_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::packages::linux::aide':
      control_package        => dig($config, 'control_package'),
      package_ensure         => dig($config, 'package_ensure'),
      manage_config          => dig($config, 'manage_config'),
      conf_purge             => dig($config, 'conf_purge'),
      run_scheduled          => dig($config, 'run_scheduled'),
      scheduler              => dig($config, 'scheduler'),
      systemd_timer_schedule => dig($config, 'systemd_timer_schedule'),
      conf_source            => dig($config, 'conf_source'),
      conf_db_dir            => dig($config, 'conf_db_dir'),
      conf_log_dir           => dig($config, 'conf_log_dir'),
      conf_verbosity         => dig($config, 'conf_verbosity'),
      conf_report_urls       => dig($config, 'conf_report_urls'),
      conf_rules             => dig($config, 'conf_rules'),
      conf_checks            => dig($config, 'conf_checks'),
    }
  }
}
