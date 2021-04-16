# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::packages::ntp
class abide_linux::utils::packages::linux::ntp (
  Optional[Boolean] $manage_package = undef,
  Optional[Array[String[1]]] $restricts = undef,
  Optional[Array[String[1]]] $timeservers = undef,
  Optional[String[1]] $sysconfig_options = undef,
  Optional[String[1]] $systemd_exec_start = undef,
) {
  include stdlib

  $_manage_package = undef_default($manage_package, true)
  $_sysconfig_options = undef_default($sysconfig_options, '-u ntp:ntp')

  if $_manage_package {
    package { 'abide_ntp':
      ensure => 'installed',
      name   => 'ntp',
      notify => Shellvar['OPTIONS'],
    }
  }
  shellvar { 'OPTIONS':
    ensure => present,
    target => '/etc/sysconfig/ntpd',
    value  => $_sysconfig_options,
  }
  if $restricts {
    Augeas {
      context => '/files/etc/ntp.conf'
    }
    augeas { 'ntp_remove_generic_restrict_default':
      changes => 'rm restrict[. = "default"]',
    }
    $restricts.each | String $res | {
      $rparts = split($res, /\s+/)
      augeas { "ntp_restrict_${rparts[0]}":
        changes => "set restrict[last()+1] ${1}",
      }
      if size($rparts) > 1 {
        $rparts[1, -1].each | String $sp | {
          augeas { "ntp_restrict+${rparts[0]}_action_${sp}":
            changes => "set restrict[last()]/action[last()+1] ${sp}",
          }
        }
      }
    }
  }
  if $timeservers {
    Augeas {
      context => '/files/etc/ntp.conf'
    }
    $_parts = split($timeservers[0], /\s+/)
    augeas { "ntp_${_parts[0]}_${_parts[1]}":
      changes => "set ${_parts[0]}[1] ${_parts[1]}",
    }
    if size($_parts) > 2 {
      $_parts[2, -1].each | String $prt | {
        augeas { "ntp_${_parts[0]}_${_parts[1]}_${prt}":
          changes => "touch ${_parts[0]}[1]/${prt}",
        }
      }
    }
    if size($timeservers) > 1 {
      $timeservers[1, -1].each | String $svr | {
        $_sparts = split($svr, /\s+/)
        augeas { "ntp_${_sparts[0]}_${_sparts[1]}":
          changes => "set ${_sparts[0]}[last()+1] ${_sparts[1]}",
        }
        if size($_sparts) > 2 {
          $_sparts[2, -1].each | String $sprt | {
            augeas { "ntp_${_sparts[0]}_${_sparts[1]}_${sprt}":
              changes => "touch ${_sparts[0]}[last()]/${sprt}",
            }
          }
        }
      }
    }
  }
}
