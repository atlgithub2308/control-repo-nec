# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_system_accounts_are_secure
class abide_linux::benchmarks::cis::controls::ensure_default_group_for_the_root_account_is_gid_0 (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_system_accounts_are_secure.')
  }
}
