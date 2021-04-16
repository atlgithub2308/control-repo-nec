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
# @see abide_linux::utils::network::enable_reverse_path_filtering
class abide_linux::benchmarks::cis::controls::ensure_reverse_path_filtering_is_enabled (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::network::enable_reverse_path_filtering':
    target  => dig($config, 'target'),
    persist => dig($config, 'persist'),
    comment => dig($config, 'comment'),
  }
}
