# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::packages::absenter
class abide_linux::benchmarks::cis::controls::ensure_netsnmp_is_not_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    abide_linux::utils::packages::absenter { 'net-snmp': }
  }
}
