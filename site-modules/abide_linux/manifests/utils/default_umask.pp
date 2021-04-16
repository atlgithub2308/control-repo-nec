# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::default_umask
class abide_linux::utils::default_umask (
  Optional[String[1]] $script_name = undef,
  Optional[Pattern[/^[0-7][0-7][0-7]$/]] $umask = undef,
) {
  $_script_name = undef_default($script_name, '999-default_umask.sh')
  $_umask = undef_default($umask, '027')

  file { 'abide_default_umask':
    ensure  => file,
    path    => "/etc/profile.d/${_script_name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "umask ${_umask}",
  }
}
