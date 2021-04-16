# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_firewalld_is_installed
class abide_linux::benchmarks::cis::controls::ensure_network_interfaces_are_assigned_to_appropriate_zone (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('This control requires manual configuration of the class ensure_firewalld_is_installed.')
  }
}
