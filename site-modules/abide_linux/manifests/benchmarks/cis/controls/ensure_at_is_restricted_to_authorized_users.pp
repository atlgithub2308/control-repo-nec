# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] purge_at_deny
# @option config [Boolean] set_at_allow_perms
# @option config [Array[String[1]]] at_allowlist
#
# @see abide_linux::utils::packages::linux::at
class abide_linux::benchmarks::cis::controls::ensure_at_is_restricted_to_authorized_users (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::packages::linux::at':
    purge_at_deny   => dig($config, 'purge_at_deny'),
    manage_at_allow => dig($config, 'manage_at_allow'),
    at_allowlist    => dig($config, 'at_allowlist'),
  }
}
