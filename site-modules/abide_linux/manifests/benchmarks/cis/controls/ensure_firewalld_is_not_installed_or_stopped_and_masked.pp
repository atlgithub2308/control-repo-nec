# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_iptables_packages_are_installed
class abide_linux::benchmarks::cis::controls::ensure_firewalld_is_not_installed_or_stopped_and_masked (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This controls is convered by ensure_iptables_packages_are_installed.')
  }
}
