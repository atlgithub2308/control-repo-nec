# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see tasks/query_listening_services.json
class abide_linux::benchmarks::cis::controls::ensure_nonessential_services_are_removed_or_masked (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt task "query_listening_services" and verify the results.')
  }
}
