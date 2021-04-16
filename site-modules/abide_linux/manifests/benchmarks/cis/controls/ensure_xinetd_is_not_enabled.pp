# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::disable_service
class abide_linux::benchmarks::cis::controls::ensure_xinetd_is_not_enabled (
  Boolean $enforced = true,
  Hash $config = {}
) {
  if $enforced {
    abide_linux::utils::disable_service { 'xinetd': }
  }
}
