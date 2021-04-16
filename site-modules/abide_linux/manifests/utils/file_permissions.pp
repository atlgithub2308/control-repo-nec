# @summary Manages permissions on a file
#
# Similar to the permissions aspect of the File resource,
# this defined type allows you to set the owner, group,
# and mode of a file. This allows for not managing a
# file via a file resource, but just setting permissions.
# You can also choose to manage only the ownership or
# only the permissions mode of the file.
#
# @param [Stdlib::AbsolutePath] path
#   The path to the file to manage. Defaults to the
#   resource title if not specified.
# @param [Boolean] manage_ownership
#   If false, ownership of the file will not be managed.
# @param [Boolean] manage_mode
#   If false, the mode (permissions) of the file will
#   not be managed.
# @param [String[1]] owner
#   The user who owns the file.
# @param [String[1]] group
#   The group that owns the file.
# @param [Pattern[/^[4-7][0-7][0-7]$/]] mode
#   The octal permissions for the file. Do not use a leading zero.
#
# @example
#   abide_linux::utils::file_permissions { '/etc/passwd':
#     owner => 'root',
#     group => 'root',
#     mode  => '644',
#   }
define abide_linux::utils::file_permissions (
  Stdlib::AbsolutePath $path = $title,
  Boolean $manage_ownership = true,
  Boolean $manage_mode = true,
  String[1] $owner = 'root',
  String[1] $group = 'root',
  Pattern[/^[0-7][0-7][0-7]$/] $mode = '755',
) {
  $_mode = $mode ? {
    '000' => '0',
    default => $mode,
  }
  Exec {
    path     => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    provider => 'shell',
  }
  if $manage_ownership {
    exec { "Abide file permissions - ownership for ${path}":
      command => "chown ${owner}:${group} ${path}",
      unless  => "[[ \$(stat -c %U:%G ${path}) =~ '${owner}:${group}' ]]",
    }
  }
  if $manage_mode {
    exec { "Abide file permissions - mode for ${path}":
      command => "chmod ${mode} ${path}",
      unless  => "[[ \$(stat -c %a ${path}) =~ ${_mode} ]]",
    }
  }
}
