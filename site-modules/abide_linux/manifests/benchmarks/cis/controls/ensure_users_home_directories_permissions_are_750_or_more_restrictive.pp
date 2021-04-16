# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see plans/linux_users_and_groups.pp
class abide_linux::benchmarks::cis::controls::ensure_users_home_directories_permissions_are_750_or_more_restrictive (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt plan "abide::linux_users_and_groups" and verify the results.')
  }
}
