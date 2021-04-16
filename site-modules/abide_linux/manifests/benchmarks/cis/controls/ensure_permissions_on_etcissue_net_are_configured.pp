# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_message_of_the_day_is_configured_properly
class abide_linux::benchmarks::cis::controls::ensure_permissions_on_etcissue_net_are_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_message_of_the_day_is_configured_properly')
  }
}
