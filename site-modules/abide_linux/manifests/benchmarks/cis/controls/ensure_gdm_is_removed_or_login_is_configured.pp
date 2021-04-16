# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::packages::linux::gdm
class abide_linux::benchmarks::cis::controls::ensure_gdm_is_removed_or_login_is_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::packages::linux::gdm':
      required => dig($config, 'required'),
    }
  }
}
