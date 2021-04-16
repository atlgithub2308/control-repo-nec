# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_journald_is_configured_to_send_logs_to_rsyslog
class abide_linux::benchmarks::cis::controls::ensure_journald_is_configured_to_compress_large_log_files (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This class is covered by ensure_journald_is_configured_to_send_logs_to_rsyslog')
  }
}
