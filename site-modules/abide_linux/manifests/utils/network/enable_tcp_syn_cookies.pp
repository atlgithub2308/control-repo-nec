# @summary Configures host to enable tcp syn cookies
#
# Uses sysctl to configure the host to enable tcp syn cookies
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-enable_tcp_syn_cookies.conf`
# @param [Boolean] persist
#   If set to false, no values will be persisted to disk. Setting
#   this to false will cause $target and $comment to be ignored.
#   Default: `true`
# @param [String] comment
#   A comment to add to add to each setting.
#   Default: `MANAGED BY PUPPET`
#
# @example
#   include abide_linux::utils::network::enable_tcp_syn_cookies
class abide_linux::utils::network::enable_tcp_syn_cookies (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-enable_tcp_syn_cookies.conf',
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
  sysctl { 'net.ipv4.tcp_syncookies':
    ensure  => present,
    value   => '1',
    target  => $_target,
    persist => $_persist,
    comment => $_comment,
    notify  => Exec['tsc_flush_ip_routes']
  }
  # This ensures subsequent new connections will use new values
  # Only needs to be set after changes.
  exec { 'tsc_flush_ip_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
