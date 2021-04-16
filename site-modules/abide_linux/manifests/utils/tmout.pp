# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::tmout
class abide_linux::utils::tmout (
  Optional[String[1]] $script_name = undef,
  Optional[Integer] $timeout_duration = undef,
) {
  $_script_name = undef_default($script_name, '999-tmout.sh')
  $_timeout_duration = undef_default($timeout_duration, 900)

  file { 'abide_tmout_script':
    ensure  => file,
    path    => "/etc/profile.d/${_script_name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "readonly TMOUT=${_timeout_duration}; export TMOUT",
  }
}
