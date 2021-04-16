# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_firewalld_is_installed
class abide_linux::benchmarks::cis::controls::ensure_default_zone_is_set (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_firewalld_is_installed.')
  }
}