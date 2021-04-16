# @summary Ensures proper permissions are set on grub2 bootloader
#
# Ensures that /boot/grub2/grub.cfg and /boot/grub2/user.cfg are
# owned by root:root and have 0600 permissions. It will NOT
# create the grub2 bootloader files if they do not exist.
#
# @example
#   include abide_linux::utils::bootloader::grub2_permissions
class abide_linux::utils::bootloader::grub2_permissions(
  Optional[String[1]] $grub_cfg = undef,
  Optional[String[1]] $user_cfg = undef,
  Optional[String[1]] $user = undef,
  Optional[String[1]] $group = undef,
  Optional[String[1]] $perm_octal = undef,
) {
  $_grub_cfg = $grub_cfg ? {
    undef => '/boot/grub2/grub.cfg',
    default => $grub_cfg,
  }
  $_user_cfg = $user_cfg ? {
    undef => '/boot/grub2/user.cfg',
    default => $user_cfg,
  }
  $_user = $user ? {
    undef => 'root',
    default => $user,
  }
  $_group = $group ? {
    undef => 'root',
    default => $group,
  }
  $_perm_octal = $perm_octal ? {
    undef => '600',
    default => $perm_octal,
  }
  $_user_group = "${_user}:${_group}"
  $_path = '/bin:/sbin:/usr/bin:/usr/sbin'

  Exec {
    path => $_path,
  }

  [$_grub_cfg, $_user_cfg].each | String $_file | {
    exec { "abide_chown_${_file}":
      command => "chown ${_user_group} ${_file}",
      onlyif  => "test -f ${_file}",
      unless  => "test $(stat --format %U:%G ${_file}) = '${_user_group}'",
    }
    -> exec { "abide_chmod_${_file}":
      command => "chmod 0${_perm_octal} ${_file}",
      onlyif  => "test -f ${_file}",
      unless  => "test $(stat --format %a ${_file}) = '${_perm_octal}'",
    }
  }
}
