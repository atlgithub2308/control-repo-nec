# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_rsyslog_is_installed
class abide_linux::benchmarks::cis::controls::ensure_rsyslog_service_is_enabled_and_running (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_rsyslog_is_installed.')
  }
}
