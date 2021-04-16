# @summary Enables logging of suspicious packets (martians)
#
# Uses sysctl to enable logging of suspicious packets (martians)
# on the host.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-enable_log_martians.conf`
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
class abide_linux::utils::network::enable_log_martians (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-enable_log_martians.conf',
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
    'net.ipv4.conf.all.log_martians',
    'net.ipv4.conf.default.log_martians',
  ]
  abide_linux::utils::multi_sysctl { 'enable_log_martians':
    value    => '0',
    settings => $_settings,
    target   => $_target,
    persist  => $_persist,
    comment  => $_comment,
    notify   => Exec['lm_flush_ip_routes']
  }
  # This ensures subsequent new connections will use new values
  # Only needs to be set after changes.
  exec { 'lm_flush_ip_routes':
    command     => 'sysctl -w net.ipv4.route.flush=1 && sysctl -w net.ipv6.route.flush=1',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
