# @summary Enables and configures the tmp.mount service
#
# Enables and configures the tmp.mount service in systemd.
# The tmp.mount service is a built-in systemd service that
# mounts /tmp with the tmpfs filesystem.
#
# @see https://www.kernel.org/doc/html/latest/filesystems/tmpfs.html
#
# @param [Optional[Boolean]] noexec
#   Adds 'noexec' to the tmp.mount unit file options.
#   Default: true
#
# @param [Optional[Boolean]] nodev
#   Adds 'nodev' to the tmp.mount unit file options.
#
# @param [Optional[Boolean]] nosuid
#   Adds 'nosuid' to the tmp.mount unit file options. 
#
# @param [Optional[Array[String]]] other_options
#   Other options to be added to the tmp.mount unit file options.
#
# @example
#   include abide_linux::utils::services::systemd::tmp_mount
#
# @example
#   class { 'abide_linux::utils::services::systemd::tmp_mount':
#     noexec        => true,
#     nodev         => true,
#     nosuid        => true,
#     other_options => ['mode=1777', 'strictatime'],
#   }
class abide_linux::utils::services::systemd::tmp_mount (
  Optional[Boolean] $noexec = undef,
  Optional[Boolean] $nodev = undef,
  Optional[Boolean] $nosuid = undef,
  Optional[Array[String]] $other_options = undef,
) {
  include systemd

  $_noexec = $noexec ? {
    undef => true,
    default => $noexec,
  }
  $_nodev = $nodev ? {
    undef => true,
    default => $nodev,
  }
  $_nosuid = $nosuid ? {
    undef => true,
    default => $nosuid,
  }
  $_other_options = $other_options ? {
    undef => ['mode=1777', 'strictatime'],
    default => $other_options,
  }
  $_path = $facts['os']['family'] ? {
    'RedHat' => '/usr/lib/systemd/system',
    default => '/etc/systemd/system',
  }
  $_cond_options = conditional_array([$noexec, 'noexec'], [$nodev, 'nodev'], [$nosuid, 'nosuid'])
  $options = combine_arrays(true, true, $_cond_options, $_other_options)

  systemd::unit_file { 'tmp.mount':
    path    => $_path,
    content => epp("${module_name}/systemd/tmp.mount.epp", { 'options' => $options }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  ~> service { 'tmp.mount':
    ensure => 'running',
    enable => true,
  }
}
