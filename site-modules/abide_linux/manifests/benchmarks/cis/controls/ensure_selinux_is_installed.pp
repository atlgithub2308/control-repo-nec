# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] manage_package
# @option config [String] package_name
# @option config [Enum[permissive, enforcing]] mode
# @option config [Enum[targeted, mls]] type
# @option config [Boolean] ensure_not_disabled_in_bootloader
#
# @see abide_linux::utils::packages::linux::selinux
class abide_linux::benchmarks::cis::controls::ensure_selinux_is_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::packages::linux::selinux':
      manage_package                    => dig($config, 'manage_package'),
      package_name                      => dig($config, 'package_name'),
      mode                              => dig($config, 'mode'),
      type                              => dig($config, 'type'),
      ensure_not_disabled_in_bootloader => dig($config, 'ensure_not_disabled_in_bootloader'),
    }
  }
}
