# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] group_name
# @option config [String] group_gid
#
# @see abide_linux::utils::restrict_su
class abide_linux::benchmarks::cis::controls::ensure_access_to_the_su_command_is_restricted (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::restrict_su':
      group_name => dig($config, 'group_name'),
      group_gid  => dig($config, 'group_gid'),
    }
  }
}
