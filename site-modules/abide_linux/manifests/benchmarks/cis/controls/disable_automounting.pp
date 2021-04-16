# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::disable_service
class abide_linux::benchmarks::cis::controls::disable_automounting (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    abide_linux::utils::disable_service { 'autofs': }
  }
}
