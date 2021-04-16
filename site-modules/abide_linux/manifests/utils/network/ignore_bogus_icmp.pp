# @summary Configures host to ignore logging non-RFC compliant ICMP responses
#
# Uses sysctl to configure the host to ignore logging non-RFC-1122 compliant
# ICMP responses from broadcast reframes.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-ignore_bogus_icmp.conf`
# @param [Boolean] persist
#   If set to false, no values will be persisted to disk. Setting
#   this to false will cause $target and $comment to be ignored.
#   Default: `true`
# @param [String] comment
#   A comment to add to add to each setting.
#   Default: `MANAGED BY PUPPET`
#
# @example
#   include abide_linux::utils::network::ignore_bogus_icmp
class abide_linux::utils::network::ignore_bogus_icmp (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-ignore_bogus_icmp.conf',
    default => $target,
  }
  $_persist = $persist ? {
    undef => true,
    default => $persist,
  }
  $_comment = $comment ? {
    undef => 'MANAGED BY PUPPET',
    default => $comment,
  }
  sysctl { 'net.ipv4.icmp_ignore_bogus_error_responses':
    ensure  => present,
    value   => '1',
    target  => $_target,
    persist => $_persist,
    comment => $_comment,
    notify  => Exec['ibi_flush_ip_routes']
  }
  # This ensures subsequent new connections will use new values
  # Only needs to be set after changes.
  exec { 'ibi_flush_ip_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
