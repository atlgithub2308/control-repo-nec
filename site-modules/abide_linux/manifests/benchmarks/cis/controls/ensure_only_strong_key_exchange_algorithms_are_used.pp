# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_permissions_on_etcsshsshd_config_are_configured
class abide_linux::benchmarks::cis::controls::ensure_only_strong_key_exchange_algorithms_are_used (
  Boolean $enforced = true,
  Hash $config = {}
) {
  if $enforced {
    debug('This control is covered by ensure_permissions_on_etcsshsshd_config_are_configured.')
  }
}
