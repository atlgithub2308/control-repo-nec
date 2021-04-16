# @summary Enables reverse path filtering
#
# Uses sysctl to enable reverse path filtering on the host
# which will drop packets that do not go out the same
# the same interface they came in. This will break any
# dynamic routing protocols in use on the host.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-enable_reverse_path_filtering.conf`
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
#   include abide_linux::utils::network::enable_log_martians
class abide_linux::utils::network::enable_reverse_path_filtering (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-enable_reverse_path_filtering.conf',
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
    'net.ipv4.conf.all.rp_filter',
    'net.ipv4.conf.default.rp_filter',
  ]
  abide_linux::utils::multi_sysctl { 'enable_reverse_path_filtering':
    value    => '1',
    settings => $_settings,
    target   => $_target,
    persist  => $_persist,
    comment  => $_comment,
    notify   => Exec['rpf_flush_ip_routes']
  }
  # This ensures subsequent new connections will use new values
  # Only needs to be set after changes.
  exec { 'rpf_flush_ip_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1 && sysctl -w net.ipv6.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
