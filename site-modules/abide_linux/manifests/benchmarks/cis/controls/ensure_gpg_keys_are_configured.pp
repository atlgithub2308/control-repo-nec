# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see tasks/query_rpm_gpg_keys
class abide_linux::benchmarks::cis::controls::ensure_gpg_keys_are_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt task "query_rpm_gpg_keys" and verify the results.')
  }
}
