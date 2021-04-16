# @summary Creates drop-in files to manage sudoer users and groups
#
# Creates drop-in files to manage sodoer users and groups. Before
# the drop-in file is created, `visudo -c` is ran against the file
# to ensure the syntax is correct.
#
# @param [Variant[String[1], Array[String[1]]]] user_group
#   The user(s) / group(s) you want to manage. Defaults to the
#   resource title, however multiple users and groups can be
#   specified by setting user_group to an Array value. NOTE:
#   group names MUST be prefixed with a `%` symbol as these
#   are passed unmodified into the drop-in file.
# @param [String[1]] host
#   Which host to assign in the sudoers statement.
# @param [Variant[String[1], Array[String[1]]]] target_users
#   A user or array of users or user specifications to assign in the sudoers statement.
# @param [Integer] priority
#   A numerical prefix added to the drop-in file name.
# @param [Stdlib::UnixPath] sudoers_dir
#   The directory where you want to create the drop-in file.
# @param [Variant[Enum['ALL'], Array[String[1]]]] commands
#   Which commands to assign in the sudoers statement.
# @param [Optional[Array[String[1]]]] options
#   Options to add to the sudoers statement.
# @param [Optional[String[1]]] file_name
#   An optional file name. Specifying this will override the dynamically
#   generated file name. This WILL NOT change the sudoers directory path.
#
# @example Give "admins" group full sudo access with no password
#   abide_linux::utils::packages::linux::sudo::user_group { '%admins':
#     options => ['NOPASSWD:'],
#   }
#
# @example Give users test1 and test2 limited sudo access
#   abide_linux::utils::packages::linux::sudo::user_group { 'limited_admin':
#     user_group   => ['test1', 'test2'],
#     target_users => ['NETWORKING', 'SOFTWARE'],
#     commands     => ['/usr/bin/stat', '/usr/sbin/ip'],
#   }
define abide_linux::utils::packages::linux::sudo::user_group (
  Variant[String[1], Array[String[1]]] $user_group = $title,
  String[1] $host = 'ALL',
  Variant[String[1], Array[String[1]]] $target_users = 'ALL',
  Integer $priority = 10,
  Stdlib::UnixPath $sudoers_dir = '/etc/sudoers.d',
  Variant[Enum['ALL'], Array[String[1]]] $commands = 'ALL',
  Optional[Array[String[1]]] $options = undef,
  Optional[String[1]] $file_name = undef,
) {
  $_options = undef_default($options, [])
  if $user_group =~ String {
    $_file_name = undef_default($file_name, regsubst($user_group, '%', 'group_'))
  } else {
    $_file_name = undef_default($file_name, regsubst($title, '\\s', '_'))
  }
  $_file_path = "${sudoers_dir}/${priority}-${_file_name}"
  file { "abide_sudo_user_group_${_file_path}":
    ensure       => file,
    path         => $_file_path,
    owner        => 'root',
    group        => 'root',
    mode         => '0700',
    content      => epp('abide_linux/config/sudo_user_group.epp', {
      user_group   => $user_group,
      host         => $host,
      target_users => $target_users,
      commands     => $commands,
      options      => $_options,
    }),
    validate_cmd => '$(/bin/command -v visudo) -c -f %',
  }
}
