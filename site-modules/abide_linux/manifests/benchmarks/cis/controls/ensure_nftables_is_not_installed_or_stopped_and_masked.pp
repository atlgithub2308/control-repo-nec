# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_firewalld_is_installed
class abide_linux::benchmarks::cis::controls::ensure_nftables_is_not_installed_or_stopped_and_masked (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_chargen_services_are_not_enabled.')
  }
}
