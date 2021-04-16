# @summary Helper type for remounting filesystems with new options
#
# remount_fs runs the command /bin/mount -o remount,<options> <title> to
# remount the specified file system with the new options.
#
# @example
#   abide_linux::utils::remount_fs { '/dev/shm':
#     options => ['defaults', 'noexec', 'nodev', 'nosuid'],
#   }
define abide_linux::utils::remount_fs (
  Array[String[1]] $options = ['defaults'],
) {
  $_opt_string = join($options, ',')
  Mounttab <| target == '/etc/fstab' |>
  ~> exec { "remount ${title} with ${options}":
    command     => "/bin/mount -o remount,${_opt_string} ${title}",
    onlyif      => "/bin/mount | grep -q ${title}",
    refreshonly => true,
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
  }
}
