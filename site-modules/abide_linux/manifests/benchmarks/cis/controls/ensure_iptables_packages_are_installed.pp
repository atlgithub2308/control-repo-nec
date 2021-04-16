# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] :merge_defaults
# @option config [Boolean] :purge_nftables
# @option config [Boolean] :purge_firewalld
# @option config [Boolean] :ipv6
# @option config [Boolean] :apply_pre_rules
# @option config [Boolean] :apply_post_rules
# @option config [Hash] :rules
# @option config [Integer] :ssh_port
# @option config [Integer] :puppet_port
#
# @see abide_linux::utils::firewall::iptables
class abide_linux::benchmarks::cis::controls::ensure_iptables_packages_are_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::firewall::iptables':
      merge_defaults   => dig($config, 'merge_defaults'),
      purge_nftables   => dig($config, 'purge_nftables'),
      purge_firewalld  => dig($config, 'purge_firewalld'),
      ipv6             => dig($config, 'ipv6'),
      apply_pre_rules  => dig($config, 'apply_pre_rules'),
      apply_post_rules => dig($config, 'apply_post_rules'),
      rules            => dig($config, 'rules'),
      ssh_port         => dig($config, 'ssh_port'),
      puppet_port      => dig($config, 'puppet_port'),
    }
  }
}
