# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] script_name
# @option config [String] umask
#
# @see abide_linux::utils::default_umask
class abide_linux::benchmarks::cis::controls::ensure_default_user_umask_is_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::default_umask':
      script_name => dig($config, 'script_name'),
      umask       => dig($config, 'umask'),
    }
  }
}
