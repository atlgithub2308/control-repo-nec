# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Enum[installed, latest, absent]] package_ensure
# @option config [Hash] options
#
# @see abide_linux::utils::packages::linux::sudo
# @see abide_linux::utils::packages::linux::sudo::sudoers_default
# @see abide_linux::utils::packages::linux::sudo::user_group
class abide_linux::benchmarks::cis::controls::ensure_sudo_is_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::packages::linux::sudo':
      package_ensure => dig($config, 'package_ensure'),
      options        => dig($config, 'options'),
    }
  }
}
