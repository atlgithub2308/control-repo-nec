# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] :sysctl_file
#   Path to the sysctl file to use
#
# @see abide_linux::utils::enable_aslr
class abide_linux::benchmarks::cis::controls::ensure_address_space_layout_randomization_aslr_is_enabled (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::enable_aslr':
      sysctl_file => dig($config, 'sysctl_file'),
    }
  }
}
