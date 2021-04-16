# @summary Disables accepting IPv6 router advertisements
#
# Uses sysctl to disable accepting IPv6 router advertisements on the host.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-disable_ipv6_router_advertisements.conf`
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
#   include abide_linux::utils::network::disable_ipv6_router_advertisements
class abide_linux::utils::network::disable_ipv6_router_advertisements (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-disable_ipv6_router_advertisements.conf',
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
  abide_linux::utils::multi_sysctl { 'net.ipv6.conf.all.accept_ra,net.ipv6.conf.default.accept_ra':
    value   => '0',
    target  => $_target,
    persist => $_persist,
    comment => $_comment,
    notify  => Exec['dra_flush_ipv4_routes'],
  }
  # This ensures subsequent new connections will use new values
  # Only needs to be set after changes.
  exec { 'dra_flush_ipv4_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
