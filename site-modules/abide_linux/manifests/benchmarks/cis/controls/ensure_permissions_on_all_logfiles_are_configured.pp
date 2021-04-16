# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see tasks/logfile_permissions
class abide_linux::benchmarks::cis::controls::ensure_permissions_on_all_logfiles_are_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt task "logfile_permissions" to set the correct permissions.')
  }
}
