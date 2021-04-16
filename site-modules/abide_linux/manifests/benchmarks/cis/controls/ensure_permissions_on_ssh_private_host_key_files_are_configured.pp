# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_permissions_on_etcsshsshd_config_are_configured
class abide_linux::benchmarks::cis::controls::ensure_permissions_on_ssh_private_host_key_files_are_configured (
  Boolean $enforced = true,
  Hash $config = {}
) {
  if $enforced {
    debug('This control is covered by ensure_permissions_on_etcsshsshd_config_are_configured.')
  }
}
