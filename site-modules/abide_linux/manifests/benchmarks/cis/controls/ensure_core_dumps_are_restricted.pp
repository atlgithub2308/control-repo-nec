# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] limits_file
# @option config [String] sysctl_file
# @option config [String] service_config
#
# @see abide_linux::utils::disable_core_dumps
class abide_linux::benchmarks::cis::controls::ensure_core_dumps_are_restricted (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::disable_core_dumps':
      limits_file     => dig($config, 'limits_file'),
      sysctl_file     => dig($config, 'sysctl_file'),
      service_content => dig($config, 'service_config'),
    }
  }
}
