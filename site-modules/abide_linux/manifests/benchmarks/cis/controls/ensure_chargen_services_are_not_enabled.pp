# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::services::inetd::disable
class abide_linux::benchmarks::cis::controls::ensure_chargen_services_are_not_enabled (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    include abide_linux::utils::services::inetd::disable
  }
}
