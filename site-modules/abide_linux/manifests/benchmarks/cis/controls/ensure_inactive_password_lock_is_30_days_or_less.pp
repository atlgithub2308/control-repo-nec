# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_password_expirtation_is_365_days_or_less
class abide_linux::benchmarks::cis::controls::ensure_inactive_password_lock_is_30_days_or_less (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_password_expiration_is_365_days_or_less.')
  }
}
