# @summary Manages sudo package and configuration
#
# Manages the sudo package and manages /etc/sudoers.d. Allows you
# to configure Defaults in /etc/sudoers and allows you to manage
# sudoers via drop-in files.
#
# @param [Optional[Enum[installed, latest, absent]]] package_ensure
#   Used with the sudo package resource.
# @param [Optional[Hash]] options
#   A hash of options for configuring sudo and sudoers.
# @option options [Hash] defaults
#   Creates Defaults in /etc/sudoers
# @option options [Hash] user_group
#   Creates drop-in sudoer files for users / groups.
#
# @example
#   include abide_linux::utils::sudo
class abide_linux::utils::packages::linux::sudo (
  Optional[Enum['installed', 'latest', 'absent']] $package_ensure = undef,
  Optional[Hash] $options = undef,
) {
  $_package_ensure = $package_ensure ? {
    undef => 'installed',
    default => $package_ensure,
  }
  $_options = $options ? {
    undef => {},
    default => $options,
  }
  $_sudoers_dir = dig($_options, 'sudoers_dir') ? {
    undef => '/etc/sudoers.d',
    default => dig($_options, 'sudoers_dir'),
  }
  package { 'abide_sudo':
    ensure => $package_ensure,
    name   => 'sudo',
  }
  ~> file { "abide_${_sudoers_dir}":
    ensure => directory,
    path   => $_sudoers_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }
  $conf_defaults = dig($_options, 'defaults')
  $conf_user_group = dig($_options, 'user_group')
  if $conf_defaults !~ Undef {
    $conf_defaults.each | Hash $def | {
      if dig($def, 'key') !~ Undef {
        abide_linux::utils::packages::linux::sudo::sudoers_default { $def['key']:
          sudoers_path => dig($def, 'sudoers_path'),
          value        => dig($def, 'value'),
          require      => File["abide_${_sudoers_dir}"],
        }
      }
    }
  }
  if $conf_user_group !~ Undef {
    $conf_user_group.each | String $key, Hash $val | {
      abide_linux::utils::packages::linux::sudo::user_group { "abide_ug_${key}":
        user_group   => get($val, 'user_group', $key),
        host         => dig($val, 'host'),
        target_users => dig($val, 'target_users'),
        priority     => dig($val, 'priority'),
        sudoers_dir  => $_sudoers_dir,
        options      => dig($val, 'options'),
        file_name    => dig($val, 'file_name'),
        require      => File["abide_${_sudoers_dir}"],
      }
    }
  }
}
