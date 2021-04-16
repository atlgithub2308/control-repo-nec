# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Integer] pass_max_days
# @option config [Integer] pass_min_days
# @option config [Integer] pass_warn_age
# @option config [Boolean] enforce_on_current
#
# @see abide_linux::utils::logindefs
class abide_linux::benchmarks::cis::controls::ensure_password_expiration_is_365_days_or_less (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::logindefs':
      pass_max_days      => dig($config, 'pass_max_days'),
      pass_min_days      => dig($config, 'pass_min_days'),
      pass_warn_age      => dig($config, 'pass_warn_age'),
      enforce_on_current => dig($config, 'enforce_on_current'),
    }
  }
}
