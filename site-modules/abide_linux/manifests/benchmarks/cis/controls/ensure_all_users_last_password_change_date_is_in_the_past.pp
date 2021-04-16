# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
class abide_linux::benchmarks::cis::controls::ensure_all_users_last_password_change_date_is_in_the_past (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included audit_pw_change_date task and confirm results.')
  }
}
