# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   profile::cem_gha_runner_venv::env_var { 'namevar': }
define profile::cem_gha_runner_venv::env_var (
  String $key,
  String $value,
  Boolean $export = true,
  Boolean $add_to_etc_environment = true,
) {
  $var = "\$${key}"
  if $export {
    exec { "export ${key}=${value}":
      path     => '/bin:/sbin:/usr/bin:/usr/sbin',
      unless   => "[ -z ${var} ] || [ \"${var}\" = ${value} ]",
      provider => 'shell',
    }
  }
  if $add_to_etc_environment {
    file_line { "/etc/environment ${key}=${value}":
      ensure  => present,
      path    => '/etc/environment',
      line    => "${key}=${value}",
      match   => "^${key}\=",
      replace => true,
    }
  }
}
