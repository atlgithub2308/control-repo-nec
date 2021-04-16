# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_chargen_services_are_not_enabled
class abide_linux::benchmarks::cis::controls::ensure_rsh_server_is_not_enabled (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_chargen_services_are_not_enabled.')
  }
}
