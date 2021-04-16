# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::packages::chrony
class abide_linux::utils::packages::linux::chrony (
  Optional[Boolean] $manage_package = undef,
  Optional[Array[String[1]]] $timeservers = undef,
  Optional[String[1]] $sysconfig_options = undef,
) {
  include stdlib

  $_manage_package = undef_default($manage_package, true)
  $_sysconfig_options = undef_default($sysconfig_options, '-u chrony')

  if $_manage_package {
    package { 'abide_chrony':
      ensure => 'installed',
      name   => 'chrony',
      notify => Shellvar['OPTIONS'],
    }
  }
  shellvar { 'OPTIONS':
    ensure => present,
    target => '/etc/sysconfig/chronyd',
    value  => $_sysconfig_options,
  }
  if $timeservers {
    Augeas {
      context => '/files/etc/chrony.conf'
    }
    $_parts = split($timeservers[0], /\s+/)
    augeas { "chrony_${_parts[0]}_${_parts[1]}":
      changes => "set ${_parts[0]}[1] ${_parts[1]}",
    }
    if size($_parts) > 2 {
      $_parts[2, -1].each | String $prt | {
        augeas { "chrony_${_parts[0]}_${_parts[1]}_${prt}":
          changes => "touch ${_parts[0]}[1]/${prt}",
        }
      }
    }
    if size($timeservers) > 1 {
      $timeservers[1, -1].each | String $svr | {
        $_sparts = split($svr, /\s+/)
        augeas { "chrony_${_sparts[0]}_${_sparts[1]}":
          changes => "set ${_sparts[0]}[last()+1] ${_sparts[1]}",
        }
        if size($_sparts) > 2 {
          $_sparts[2, -1].each | String $sprt | {
            augeas { "chrony_${_sparts[0]}_${_sparts[1]}_${sprt}":
              changes => "touch ${_sparts[0]}[last()]/${sprt}",
            }
          }
        }
      }
    }
  }
}
