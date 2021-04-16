# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_rsyslog_is_installed
class abide_linux::benchmarks::cis::controls::ensure_remote_rsyslog_messages_are_only_accepted_on_designated_log_hosts (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_rsyslog_is_installed.')
  }
}
