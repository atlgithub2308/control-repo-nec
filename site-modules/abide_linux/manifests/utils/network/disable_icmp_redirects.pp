# @summary Disables the host from accepting ICMP redirect messages
#
# Uses sysctl to disable the host from accepting ICMP redirect
# messages. This disables the ability for outside hosts to
# update the hosts routing table.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-disable_icmp_redirects.conf`
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
#   include abide_linux::utils::network::disable_icmp_redirects
class abide_linux::utils::network::disable_icmp_redirects (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-disable_icmp_redirects.conf',
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
    'net.ipv4.conf.all.accept_redirects',
    'net.ipv4.conf.default.accept_redirects',
    'net.ipv6.conf.all.accept_redirects',
    'net.ipv6.conf.default.accept_redirects',
  ]
  abide_linux::utils::multi_sysctl { 'disable_icmp_redirects':
    value    => '0',
    settings => $_settings,
    target   => $_target,
    persist  => $_persist,
    comment  => $_comment,
    notify   => Exec['ir_flush_ip_routes'],
  }
  exec { 'ir_flush_ip_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
