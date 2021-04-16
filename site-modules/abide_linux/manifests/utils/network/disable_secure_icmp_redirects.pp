# @summary Disables the host from accepting secure ICMP redirect messages
#
# Uses sysctl to disable the host from accepting secure ICMP redirect
# messages. This disables the ability for default gateways to
# update the hosts routing table.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-disable_secure_icmp_redirects.conf`
# @param [Boolean] persist
#   If set to false, no values will be persisted to disk. Setting
#   this to false will cause $target and $comment to be ignored.
#   Default: `true`
# @param [String] comment
#   A comment to add to add to each setting.
#   Default: `MANAGED BY PUPPET`
#
# @see abide_linux::utils::multi_sysctl
#
# @example
#   include abide_linux::utils::network::disable_secure_icmp_redirects
class abide_linux::utils::network::disable_secure_icmp_redirects (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-disable_secure_icmp_redirects.conf',
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
  $_settings = [
    'net.ipv4.conf.all.secure_redirects',
    'net.ipv4.conf.default.secure_redirects',
  ]
  abide_linux::utils::multi_sysctl { 'disable_secure_icmp_redirects':
    value    => '0',
    settings => $_settings,
    target   => $_target,
    persist  => $_persist,
    comment  => $_comment,
    notify   => Exec['sir_flush_ip_routes'],
  }
  exec { 'sir_flush_ip_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
