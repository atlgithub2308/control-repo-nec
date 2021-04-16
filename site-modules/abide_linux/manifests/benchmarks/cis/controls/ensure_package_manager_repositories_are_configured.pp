# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see tasks/query_yum_repos
class abide_linux::benchmarks::cis::controls::ensure_package_manager_repositories_are_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt task "query_yum_repos" and verify the results.')
  }
}
