# @summary Disables IP forwarding for IPv4 and IPv6
#
# Uses sysctl to disable IP forwarding for both
# IPv4 and IPv6. Warning: this breaks Docker installations.
#
# @param [String[1]] target
#   The sysctl file that values will be written to.
#   Default: `/etc/sysctl.d/10-disable_ip_forwarding.conf`
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
#   include abide_linux::utils::network::disable_ip_forwarding
class abide_linux::utils::network::disable_ip_forwarding (
  Optional[String[1]] $target = undef,
  Optional[Boolean] $persist = undef,
  Optional[String] $comment = undef,
) {
  $_target = $target ? {
    undef => '/etc/sysctl.d/10-disable_ip_forwarding.conf',
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
  abide_linux::utils::multi_sysctl { 'net.ipv4.ip_forward,net.ipv6.conf.all.forwarding':
    value   => '0',
    target  => $_target,
    persist => $_persist,
    comment => $_comment,
  }
}
