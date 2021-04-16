# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see tasks/audit_unconfined_services
class abide_linux::benchmarks::cis::controls::ensure_no_unconfined_daemons_exist (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the Bolt task "audit_unconfined_services" and verify the results.')
  }
}
