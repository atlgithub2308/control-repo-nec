# @summary Disables IPv6 via sysctl or grub
#
# Disables IPv6 support on the host by either setting
# sysctl parameters in a file or by editing the grub config.
# If you chose to disable IPv6 using grub, you will need to
# regenerate the grub config on the host.
#
# @param [Enum[sysctl, grub]] strategy
#   Whether to disable IPv6 with sysctl or in the grub config
#   Default: sysctl
# @param [Boolean] create_sysctl_file
#   Whether to create a new sysctl file or to use the default config file
#   Default: true
# @param [String] sysctl_conf
#   Path to sysctl.conf.
#   Default: /etc/sysctl.conf
# @param [String] sysctl_d_path
#   Path to sysctl.d.
#   Default: /etc/sysctl.d
# @param [String] sysctl_file_name
#   If creating a new file, this is the file name.
#   Default: disable_ipv6.conf
# @param [String] prefix
#   A prefix to add to the created file name.
#   Default: 10-
# @param [String] sysctl_comment
#   A comment to add to the created file.
#   Default: MANAGED BY PUPPET
#
# @example
#   include abide_linux::utils::network::disable_ipv6
class abide_linux::utils::network::disable_ipv6 (
  Optional[Enum['sysctl', 'grub']] $strategy = undef,
  Optional[Boolean] $create_sysctl_file = undef,
  Optional[String] $sysctl_conf = undef,
  Optional[String] $sysctl_d_path = undef,
  Optional[String] $sysctl_file_name = undef,
  Optional[String] $sysctl_prefix = undef,
  Optional[String] $sysctl_comment = undef,
) {
  $_strategy = $strategy ? {
    undef => 'sysctl',
    default => $strategy,
  }
  if $_strategy == 'sysctl' {
    $_create_file = $create_sysctl_file ? {
      undef => true,
      default => $create_sysctl_file,
    }
    $_sysctl_conf = $sysctl_conf ? {
      undef => '/etc/sysctl.conf',
      default => $sysctl_conf,
    }
    $_sysctl_d_path = $sysctl_d_path ? {
      undef => '/etc/sysctl.d',
      default => $sysctl_d_path,
    }
    $_sysctl_file_name = $sysctl_file_name ? {
      undef => 'disable_ipv6.conf',
      default => $sysctl_file_name,
    }
    $_sysctl_prefix = $sysctl_prefix ? {
      undef => '10-',
      default => $sysctl_prefix,
    }
    $_sysctl_comment = $sysctl_comment ? {
      undef => 'MANAGED BY PUPPET',
      default => $sysctl_comment,
    }
    $_settings = ['net.ipv6.conf.all.disable_ipv6', 'net.ipv6.conf.default.disable_ipv6']
    if $_create_file {
      $_settings.each | String $setting | {
        sysctl { $setting:
          ensure  => present,
          value   => '1',
          comment => $_sysctl_comment,
          target  => "${_sysctl_d_path}/${_sysctl_prefix}${_sysctl_file_name}",
        }
      }
    } else {
      $_settings.each | String $setting | {
        sysctl { $setting:
          ensure => present,
          value  => '1',
          target => $_sysctl_conf,
        }
      }
    }
  } elsif $_strategy == 'grub' {
    shellvar { 'GRUB_CMDLINE_LINUX':
      ensure       => present,
      target       => '/etc/default/grub',
      value        => ['ipv6.disable=1'],
      array_append => true,
    }
    debug('If disable_ipv6 made and changes to /etc/default/grub, you will need to regenerate grub.cfg.')
  } else {
    err("Strategy ${_strategy} is invalid! Valid choices are 'sysctl' or 'grub'!")
  }
}
