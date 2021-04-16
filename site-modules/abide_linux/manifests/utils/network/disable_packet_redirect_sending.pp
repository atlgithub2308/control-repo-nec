# @summary Disables ICMP redirects on the system
#
# Uses sysctl to disable ICMP redirects from the system.
# If changes are made via sysctl, also flushes the routes
# currently held by the system so subsequent connections
# cannot send ICMP redirects.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-disable_packet_redirect_sending.conf`
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
#   include abide_linux::utils::network::disable_packet_redirect_sending
class abide_linux::utils::network::disable_packet_redirect_sending (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-disable_packet_redirect_sending.conf',
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
  abide_linux::utils::multi_sysctl { 'net.ipv4.conf.all.send_redirects,net.ipv4.conf.default.send_redirects':
    value   => '0',
    target  => $_target,
    persist => $_persist,
    comment => $_comment,
    notify  => Exec['pr_flush_ipv4_routes'],
  }
  # This ensures subsequent new connections will use new values
  # Only needs to be set after changes.
  exec { 'pr_flush_ipv4_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
