# @api private
class abide_linux::utils::firewall::iptables::post (
  Boolean $apply = true,
  Boolean $ipv6 = false,
) {
  if $apply {
    firewall { '999 drop all IPv4':
      proto  => 'all',
      action => 'drop',
      before => undef,
    }
    if $ipv6 {
      firewall { '999 drop all IPv6':
        proto    => 'all',
        action   => 'drop',
        before   => undef,
        provider => 'ip6tables',
        require  => Firewall['999 drop all IPv4']
      }
    }
  }
}
