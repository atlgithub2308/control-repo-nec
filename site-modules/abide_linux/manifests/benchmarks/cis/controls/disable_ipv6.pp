# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Enum[sysctl, grub]] :strategy
# @option config [Boolean] :create_sysctl_file
# @option config [String] :sysctl_conf
# @option config [String] :sysctl_d_path
# @option config [String] :sysctl_file_name
# @option config [String] :sysctl_prefix
# @option config [String] :sysctl_comment
#
# @see abide_linux::utils::network::disable_ipv6
class abide_linux::benchmarks::cis::controls::disable_ipv6 (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::network::disable_ipv6':
    strategy           => dig($config, 'strategy'),
    create_sysctl_file => dig($config, 'create_sysctl_file'),
    sysctl_conf        => dig($config, 'sysctl_conf'),
    sysctl_d_path      => dig($config, 'sysctl_d_path'),
    sysctl_prefix      => dig($config, 'sysctl_prefix'),
    sysctl_comment     => dig($config, 'sysctl_comment'),
  }
}
