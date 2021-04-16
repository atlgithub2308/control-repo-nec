# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_iptables_packages_are_installed
class abide_linux::benchmarks::cis::controls::ensure_ip6tables_is_enabled_and_running (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This controls is convered by ensure_iptables_packages_are_installed.')
  }
}