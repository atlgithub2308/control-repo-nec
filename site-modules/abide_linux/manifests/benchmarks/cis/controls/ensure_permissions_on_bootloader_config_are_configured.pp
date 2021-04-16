# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] grub_cfg
# @option config [String] user_cfg
# @option config [String] user
# @option config [String] group
# @option config [String] perm_octal
#
# @see abide_linux::utils::bootloader::grub2_permissions
class abide_linux::benchmarks::cis::controls::ensure_permissions_on_bootloader_config_are_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::bootloader::grub2_permissions':
      grub_cfg   => dig($config, 'grub_cfg'),
      user_cfg   => dig($config, 'user_cfg'),
      user       => dig($config, 'user'),
      group      => dig($config, 'group'),
      perm_octal => dig($config, 'perm_octal'),
    }
  }
}
