# @summary Creates modifies, or deletes and entry in /etc/fstab
#
# Allows you to create, modify, or delete an entry in /etc/fstab.
# This defined type is a convienience wrapper around mounttab,
# the augeas provider created by Hercules Team. fstab_entry does
# not expose all of the options that mountab does, so if you
# need more fine-grained control over your fstab entries,
# use mounttab directly.
#
# @see https://forge.puppet.com/modules/herculesteam/augeasproviders_mounttab
# @see https://help.ubuntu.com/community/Fstab
#
# @example Configuring secure /dev/shm mount for CentOS 7
#   abide_linux::utils::fstab_entry { '/dev/shm':
#     device => 'tmpfs',
#     fstype => 'tmpfs',
#   }
#
# @param [Enum[present, absent]] ensure
# @param [String[1]] device
# @param [String[1]] fstype
# @param [Boolean] noexec
#   Add the noexec option
# @param [Boolean] nosuid
#   Add the nosuid option
# @param [Boolean] nodev
#   Add the nodev option
# @param [Array[String[1]]] options
#   Other options to add
# @param [String[1]] dump
# @param [String[1]] pass
# @param [Enum[yes, no]] atboot
define abide_linux::utils::fstab_entry (
  Enum['present', 'absent'] $ensure = 'present',
  String[1] $device = '',
  String[1] $fstype = '',
  Boolean $noexec = true,
  Boolean $nosuid = true,
  Boolean $nodev = true,
  Array[String[1]] $options = ['defaults', 'seclabel'],
  String[1] $dump = '0',
  String[1] $pass = '0',
  Enum['yes', 'no'] $atboot = 'yes',
) {
  $_cond_options = conditional_array([$noexec, 'noexec'], [$nosuid, 'nosuid'], [$nodev, 'nodev'])
  $_options = combine_arrays(true, true, $options, $_cond_options)
  mounttab { $title:
    ensure   => $ensure,
    device   => $device,
    fstype   => $fstype,
    options  => $_options,
    dump     => $dump,
    pass     => $pass,
    atboot   => $atboot,
    target   => '/etc/fstab',
    provider => augeas,
  }
}
