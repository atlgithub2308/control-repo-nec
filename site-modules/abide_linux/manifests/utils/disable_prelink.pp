# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::disable_prelink
class abide_linux::utils::disable_prelink {
  exec { 'prelink -ua':
    onlyif   => 'command -v prelink &>/dev/null',
    path     => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    provider => 'shell',
  }
  -> package { 'prelink':
    ensure => absent,
  }
}
