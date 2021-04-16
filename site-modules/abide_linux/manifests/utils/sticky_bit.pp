# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::sticky_bit
class abide_linux::utils::sticky_bit {
  realize(File['/opt/puppetlabs/abide'], File['/opt/puppetlabs/abide/scripts'])

  # lint:ignore:140chars
  $_chk_cmd = 'df --local -P | awk \'{if (NR!=1) print $6}\' | xargs -I {} find {} -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null'
  # lint:endignore
  file { '/opt/puppetlabs/abide/scripts/sticky_bit.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/abide_linux/scripts/linux/sticky_bit.sh',
    require => File['/opt/puppetlabs/abide', '/opt/puppetlabs/abide/scripts'],
  }

  exec { 'set_sticky_bit':
    command   => '/bin/bash -c "/opt/puppetlabs/abide/scripts/sticky_bit.sh -s"',
    unless    => $_chk_cmd,
    path      => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    logoutput => 'on_failure',
    subscribe => File['/opt/puppetlabs/abide/scripts/sticky_bit.sh'],
  }
}
