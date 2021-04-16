# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::disable_prelink
class abide_linux::benchmarks::cis::controls::ensure_prelink_is_disabled (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    include abide_linux::utils::disable_prelink
  }
}
