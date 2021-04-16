# @api private
# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::disable_core_dumps
class abide_linux::utils::disable_core_dumps (
  Optional[String] $limits_file = undef,
  Optional[String] $sysctl_file = undef,
  Optional[String] $service_content = undef,
) {
  if $facts['kernel'] != 'windows' {

    $defaults = lookup('abide_linux::utils::disable_core_dumps::defaults')
    $_limits_file = $limits_file ? {
      undef => $defaults['limits_file'],
      default => $limits_file,
    }
    $_sysctl_file = $sysctl_file ? {
      undef => $defaults['sysctl_file'],
      default => $sysctl_file,
    }
    $_service_content = $service_content ? {
      undef => $defaults['service_content'],
      default => $service_content,
    }

    abide_linux::utils::limits { $_limits_file:
      content => '* hard core 0',
    }

    sysctl { 'fs.suid_dumpable':
      ensure  => present,
      value   => '0',
      target  => "/etc/sysctl.d/${_sysctl_file}",
      comment => 'MANAGED BY PUPPET',
    }

    $cd_fact = $facts['abide_coredump']
    if $cd_fact =~ Hash {
      $svc_fact = dig($cd_fact, 'service')
      if $svc_fact {
        if dig($svc_fact, 'unit_file_loaded') == 'true' {
          if dig($svc_fact, 'unit_file_exists', 'false') == 'true' {
            include systemd

            systemd::unit_file { 'coredump.service':
              content => $_service_content,
              enable  => true,
              active  => true,
            }
          }
        } elsif dig($svc_fact, 'is-active') and dig($svc_fact, 'is-active') != 'unknown' {
          service { 'coredump.service':
            ensure => running,
            enable => true,
          }
        }
      }
    }
  }
}
