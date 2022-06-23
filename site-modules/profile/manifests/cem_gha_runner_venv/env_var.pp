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
  Boolean $add_to_environment_files = false,
  Optional[Array[Stdlib::AbsolutePath]] $environment_file_paths = undef,
) {
  $var = "\$${key}"
  # if $export {
  #   exec { "export ${key}=${value}":
  #     path     => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
  #     onlyif   => "/bin/bash -c '[[ -z ${var} ]] || [[ \"$(echo ${var})\" != ${value} ]]'",
  #     provider => 'shell',
  #   }
  # }
  if $add_to_etc_environment {
    file_line { "/etc/environment ${key}=${value}":
      ensure  => present,
      path    => '/etc/environment',
      line    => "${key}=${value}",
      match   => "^${key}\=",
      replace => true,
    }
  }
  if $add_to_environment_files {
    if $environment_file_paths =~ Undef {
      fail('When $add_to_environment_files is true, $environment_file_paths must be specified')
    } else {
      $environment_file_paths.each |$efp| {
        file_line { "${efp} ${key}=${value}":
          ensure  => present,
          path    => $efp,
          line    => "${key}=${value}",
          match   => "^${key}\=",
          replace => true,
        }
      }
    }
  }
}
