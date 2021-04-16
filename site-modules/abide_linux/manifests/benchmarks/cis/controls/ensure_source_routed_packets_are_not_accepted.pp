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
# @see abide_linux::utils::network::disable_source_routes
class abide_linux::benchmarks::cis::controls::ensure_source_routed_packets_are_not_accepted (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::network::disable_source_routes':
    target  => dig($config, 'target'),
    persist => dig($config, 'persist'),
    comment => dig($config, 'comment'),
  }
}
