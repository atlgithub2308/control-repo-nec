# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_password_expiration_is_365_days_or_less
class abide_linux::benchmarks::cis::controls::ensure_minimum_days_between_password_changes_is_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_password_expiration_is_365_days_or_less.')
  }
}
