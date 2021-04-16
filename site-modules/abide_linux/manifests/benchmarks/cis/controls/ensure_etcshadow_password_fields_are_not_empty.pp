# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see plans/linux_users_and_groups.pp
class abide_linux::benchmarks::cis::controls::ensure_etcshadow_password_fields_are_not_empty (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt plan "abide::linux_users_and_groups" and verify the results.')
  }
}
