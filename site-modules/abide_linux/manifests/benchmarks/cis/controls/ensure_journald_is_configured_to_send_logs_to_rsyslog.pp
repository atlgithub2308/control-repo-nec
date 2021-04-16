# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Stdlib::AbsolutePath] :journald_conf
# @option config [Boolean] :forward_to_syslog
# @option config [Boolean] :compress_large_files
# @option config [Boolean] :persistent_storage
#
# @see abide_linux::utils::services::systemd::journald
class abide_linux::benchmarks::cis::controls::ensure_journald_is_configured_to_send_logs_to_rsyslog (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::services::systemd::journald':
      journald_conf        => dig($config, 'journald_conf'),
      forward_to_syslog    => dig($config, 'forward_to_syslog'),
      compress_large_files => dig($config, 'compress_large_files'),
      persistent_storage   => dig($config, 'persistent_storage'),
    }
  }
}
