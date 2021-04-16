# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::packages::linux::selinux::bootloader
class abide_linux::utils::packages::linux::selinux::bootloader {
  ['GRUB_CMDLINE_LINUX_DEFAULT', 'GRUB_CMDLINE_LINUX'].each | String $var | {
    shellvar { $var:
      ensure       => absent,
      target       => '/etc/default/grub',
      value        => ['selinux=0', 'enforcing=0'],
      array_append => true,
    }
  }
  debug('If selinux::bootloader made and changes to /etc/default/grub, you will need to regenerate grub.cfg.')
}
