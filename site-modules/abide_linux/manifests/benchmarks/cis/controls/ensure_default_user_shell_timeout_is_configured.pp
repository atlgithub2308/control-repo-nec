# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] script_name
# @option config [Integer] timeout_duration
#
# @see abide_linux::utils::tmout
class abide_linux::benchmarks::cis::controls::ensure_default_user_shell_timeout_is_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::tmout':
      script_name      => dig($config, 'script_name'),
      timeout_duration => dig($config, 'timeout_duration'),
    }
  }
}
