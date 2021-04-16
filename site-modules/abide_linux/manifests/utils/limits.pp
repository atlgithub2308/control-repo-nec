# @summary Creates a limits conf file
#
# Creates a supplementary limits conf file for setting
# security limits configs on Linux machines. This DOES
# NOT overwrite the actual /etc/security/limits.conf
# file, but instead creates a file in /etc/security/limits.d/.
#
# @param [String] name
#   The resource name is used to create the filename.
#   The resource name should end in ".conf".
#
# @param [String] owner
#   The file's owner.
#
# @param [String] group
#   The file's group.
#
# @param [String] mode
#   The file's mode.
#
# @param [Optional[String]] content
#   A string that is passed into the file. Also allows for
#   templating the file. Mututally exclusive with source.
#
# @param [Optional[String]] source
#   A path to a file that will be used as the limits file.
#   Mutually exclusive with content.
#
# @example
#   abide_linux::utils::limits { 'disable-coredumps': 
#     priority => '10',
#     content  => '* hard core 0',
#   }
define abide_linux::utils::limits (
  String[1] $owner = 'root',
  String[1] $group = 'root',
  String[1] $mode  = '0644',
  Optional[String[1]] $content = undef,
  Optional[String[1]] $source = undef,
) {
  if !require_one($content, $source) {
    fail('You must set either content or source paramter')
  }
  if !is_mutex($content, $source) {
    fail('Parameters content and source are mutually exclusive')
  }
  $path = $facts['os']['family'] ? {
    default => '/etc/security/limits.d',
  }

  file { "${path}/${name}":
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    source  => $source,
  }
}
