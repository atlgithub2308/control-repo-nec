# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_time_synchronization_is_in_use
class abide_linux::benchmarks::cis::controls::ensure_chrony_is_configured (
  Boolean $enforced = true,
  Hash $config = {}
) {
  if $enforced {
    debug('This control is covered by ensure_time_synchronization_is_in_use.')
  }
}
