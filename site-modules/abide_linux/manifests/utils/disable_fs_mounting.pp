# @summary Disables filesystem mounting in Linux
#
# Disables filesystem mounting in Linux by creating
# a modprobe conf file and running rmmod on the
# filesystem. WILL NOT disable vfat if the node
# booted from UEFI as UEFI requires vfat.
#
# @example
#   abide_linux::utils::disable_fs_mounting { 'filesystem': }
define abide_linux::utils::disable_fs_mounting (
  String[1] $filesystem = $title,
) {
  if $facts['abide_uefi_boot'] == 'true' and $filesystem == 'vfat' {
    debug('UEFI requires vfat filesystem, will not disable mounting of vfat filesystem.')
  } else {
    abide_linux::utils::modprobe_conf { $filesystem:
      content => "install ${filesystem} /bin/true",
    }

    exec { "rmmod -s ${filesystem}":
      onlyif    => "lsmod | grep -q ${filesystem}",
      subscribe => Abide_linux::Utils::Modprobe_conf[$filesystem],
      path      => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
  }
}
