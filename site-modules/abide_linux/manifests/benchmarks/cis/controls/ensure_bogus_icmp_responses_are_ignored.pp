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
# @see abide_linux::utils::network::ignore_bogus_icmp
class abide_linux::benchmarks::cis::controls::ensure_bogus_icmp_responses_are_ignored (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::network::ignore_bogus_icmp':
    target  => dig($config, 'target'),
    persist => dig($config, 'persist'),
    comment => dig($config, 'comment'),
  }
}
