# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] :target
# @option config [Boolean] :persist
# @option config [String] :comment
#
# @see abide_linux::utils::network::disable_ipv6_router_advertisements
class abide_linux::benchmarks::cis::controls::ensure_ipv6_router_advertisements_are_not_accepted (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::network::disable_ipv6_router_advertisements':
    target  => dig($config, 'target'),
    persist => dig($config, 'persist'),
    comment => dig($config, 'comment'),
  }
}
