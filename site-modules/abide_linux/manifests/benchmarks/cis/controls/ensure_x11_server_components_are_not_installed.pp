# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::packages::absenter
class abide_linux::benchmarks::cis::controls::ensure_x11_server_components_are_not_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    abide_linux::utils::packages::absenter { 'xorg-x11-server*': }
  }
}
