# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
class abide_linux::benchmarks::cis::controls::ensure_all_users_home_directories_exist (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt plan "abide::linux_users_and_groups" and verify the results.')
  }
}
