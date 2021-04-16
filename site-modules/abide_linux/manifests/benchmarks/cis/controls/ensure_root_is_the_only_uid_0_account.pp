# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see plan/linux_users_and_groups.pp
class abide_linux::benchmarks::cis::controls::ensure_root_is_the_only_uid_0_account (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt plan "abide::linux_users_and_groups" and verify the results.')
  }
}
