# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_cron_daemon_is_enabled_and_running
class abide_linux::benchmarks::cis::controls::ensure_permissions_on_etccrontab_are_configured (
  Boolean $enforced = true,
  Hash $config = {}
) {
  if $enforced {
    debug('This control is covered by ensure_cron_daemon_is_enabled_and_running.')
  }
}
