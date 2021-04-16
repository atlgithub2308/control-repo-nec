# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_message_of_the_day_is_configured_properly
class abide_linux::benchmarks::cis::controls::ensure_local_login_warning_banner_is_configured_properly (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_message_of_the_day_is_configured_properly')
  }
}
