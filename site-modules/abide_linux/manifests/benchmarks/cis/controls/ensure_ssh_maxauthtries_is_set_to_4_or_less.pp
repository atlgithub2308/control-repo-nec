# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_permissions_on_etchsshsshd_config_are_configured
class abide_linux::benchmarks::cis::controls::ensure_ssh_maxauthtries_is_set_to_4_or_less (
  Boolean $enforced = true,
  Hash $config = {}
) {
  if $enforced {
    debug('This control is covered by ensure_permissions_on_etcsshsshd_config_are_configured.')
  }
}
