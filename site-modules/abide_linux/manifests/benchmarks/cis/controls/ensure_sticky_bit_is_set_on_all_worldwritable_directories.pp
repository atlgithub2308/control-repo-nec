# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::sticky_bit
class abide_linux::benchmarks::cis::controls::ensure_sticky_bit_is_set_on_all_worldwritable_directories (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    include abide_linux::utils::sticky_bit
  }
}
