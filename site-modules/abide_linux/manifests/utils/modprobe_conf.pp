# @summary Creates a new modprobe config file
#
# By default, this type creates a new `.conf` file in `/etc/modprobe.d`
# with the file name being the resource title. It is unnecessary to add
# `.conf` to the file name, as it will be appended to the file name
# string.
#
# @param [String[1]] conf_file
#   A unique name for the config file without a path of file extension
# @param [String[1]] owner
#   Owner of file
# @param [String[1]] group
#   Owner group of file
# @param [String[1]] mode
#   File permissions mode
# @param [String[1]] basepath
#   The path to the modprobe directory
# @param [String[1]] extension
#   The file extension for the new file
# @param [Optional[String]] content
#   The file content. Mutually exclusive with source.
# @param [Optional[String]] source
#   The file source. Mutually exclusive with content.
#
# @see https://puppet.com/docs/puppet/6.20/types/file.html
#
# @example
#   abide_linux::utils::modprobe_conf { 'dccp': }
define abide_linux::utils::modprobe_conf (
  String[1] $conf_file = $title,
  String[1] $owner = 'root',
  String[1] $group = 'root',
  String[1] $mode = '0644',
  String[1] $basepath = '/etc/modprobe.d',
  String[1] $extension = '.conf',
  Optional[String] $content = undef,
  Optional[String] $source = undef,
) {
  if $content !~ Undef and $source !~ Undef {
    fail('Parameters content and source are mutually exclusive')
  }
  $_filename = "${basepath}/${conf_file}${extension}"
  file { $_filename:
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
  if $content {
    File[$_filename] {
      content => $content,
    }
  }
  if $source {
    File[$_filename] {
      source => $source,
    }
  }
}
