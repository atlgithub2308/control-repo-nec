# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] enforce_nologin
# @option config [Boolean] enforce_root_default_gid
#
# @see abide_linux::utils::account_hardening
class abide_linux::benchmarks::cis::controls::ensure_system_accounts_are_secure (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::account_hardening':
      enforce_nologin          => dig($config, 'enforce_nologin'),
      enforce_root_default_gid => dig($config, 'enforce_root_default_gid'),
    }
  }
}
