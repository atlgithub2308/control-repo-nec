# @summary Disables source routing on host
#
# Uses sysctl to disable source routing on the host.
# This defers all routing to the network paths created
# by actual routers.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-disable_source_routes.conf`
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
#   include abide_linux::utils::network::disable_source_routes
class abide_linux::utils::network::disable_source_routes (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-disable_source_routes.conf',
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
    'net.ipv4.conf.all.accept_source_route',
    'net.ipv4.conf.default.accept_source_route',
    'net.ipv6.conf.all.accept_source_route',
    'net.ipv6.conf.default.accept_source_route'
  ]
  abide_linux::utils::multi_sysctl { 'disable_source_routes':
    value    => '0',
    settings => $_settings,
    target   => $_target,
    persist  => $_persist,
    comment  => $_comment,
    notify   => Exec['dsr_flush_ip_routes']
  }
  # This ensures subsequent new connections will use new values
  # Only needs to be set after changes.
  exec { 'dsr_flush_ip_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1 && sysctl -w net.ipv6.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
