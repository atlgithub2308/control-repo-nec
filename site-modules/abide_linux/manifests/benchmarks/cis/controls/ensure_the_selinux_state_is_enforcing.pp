# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_selinux_is_installed
class abide_linux::benchmarks::cis::controls::ensure_the_selinux_state_is_enforcing (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_selinux_is_installed')
  }
}
