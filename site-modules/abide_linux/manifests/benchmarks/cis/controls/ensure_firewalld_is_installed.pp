# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Enum[present, installed, latest]] :ensure_package
# @option config [Enum[present, installed, latest]] :ensure_iptables_package
# @option config [Boolean] :merge_defaults
# @option config [Boolean] :purge_iptables_services
# @option config [Boolean] :purge_nftables
# @option config [String[1]] :default_zone
# @option config [Hash] :zones
# @option config [Hash] :ports
# @option config [Hash] :services
# @option config [Hash] :rich_rules
# @option config [Hash] :custom_services
# @option config [Hash] :ipsets
# @option config [Hash] :direct_rules
# @option config [Hash] :direct_chains
# @option config [Hash] :direct_passthroughs
# @option config [Boolean] :purge_direct_rules
# @option config [Boolean] :purge_direct_chains
# @option config [Boolean] :purge_direct_passthroughs
# @option config [Boolean] :purge_unknown_ipsets
# @option config [Enum[off, all, unicast, broadcast, multicast]] log_denied
# @option config [Enum[yes, no]] cleanup_on_exit
# @option config [Enum[yes, no]] zone_drifting
# @option config [Integer] minimal_mark
# @option config [Enum[yes, no]] lockdown
# @option config [Enum[yes, no]] ipv6_rpfilter
# @option config [String[1]] default_service_zone
# @option config [String[1]] default_port_zone
# @option config [String[1]] default_port_protocol
#
# @see abide_linux::utils::firewall::firewalld
class abide_linux::benchmarks::cis::controls::ensure_firewalld_is_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::firewall::firewalld':
    * => $config,
  }
}
