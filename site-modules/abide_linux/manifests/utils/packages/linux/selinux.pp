# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::packages::linux::selinux
class abide_linux::utils::packages::linux::selinux (
  Optional[Boolean] $manage_package = undef,
  Optional[String[1]] $package_name = undef,
  Optional[Enum['permissive', 'enforcing']] $mode = undef,
  Optional[Enum['targeted', 'mls']] $type = undef,
  Optional[Boolean] $ensure_not_disabled_in_bootloader = undef,
) {
  $_manage_package = $manage_package ? {
    undef => true,
    default => $manage_package,
  }
  $_package_name = $package_name ? {
    undef => 'libselinux',
    default => $package_name,
  }
  $_mode = $mode ? {
    undef => 'permissive',
    default => $mode,
  }
  $_type = $type ? {
    undef => 'targeted',
    default => $type,
  }
  $_ensure_not_disabled_in_bootloader = $ensure_not_disabled_in_bootloader ? {
    undef => true,
    default => $ensure_not_disabled_in_bootloader,
  }
  if $_ensure_not_disabled_in_bootloader {
    include abide_linux::utils::packages::linux::selinux::bootloader
  }
  package { 'selinux-policy':
    ensure => installed,
  }
  -> file { '/etc/selinux/config':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
  class { 'selinux':
    manage_package => $_manage_package,
    package_name   => $_package_name,
  }
}
