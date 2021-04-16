# @summary Configures iptables as a firewall on the host
#
# Provides a wrapper around the firewall resource from
# the puppetlabs/firewall module to configure iptables
# as a firewall on the host. Also includes some default
# rules to ensure that the host doesn't lock itself down
# to the point where it is unreachable.
#
# @param [Optional[Boolean]] merge_defaults
#   Whether or not to merge the default settings with
#   any user-supplied settings. Default: true
# @param [Optional[Boolean]] purge_nftables
#   Whether to remove the nftables package. Setting
#   this to false will instead disable and mask the
#   nftables service (if present). Default: true
# @param [Optional[Boolean]] purge_firewalld
#   Whether to remove the firewalld package. Setting
#   this to false will instead disable and mask the
#   firewalld service (if present). Default: true
# @param [Optional[Boolean]] ipv6
#   Whether IPv6 firewall rules should also be created.
#   Default: true
# @param [Optional[Boolean]] apply_pre_rules
#   Whether or not to apply rules to configure the loopback
#   interface and to open ports for SSH and the Puppet Agent
#   before any other rules are applied. Default: true
# @param [Optional[Boolean]] apply_post_rules
#   Whether or not to apply a default drop rule after all
#   other rules are applied. Default: true
# @param [Optional[Hash]] rules
#   Allows you to specify custom firewall rules. The hash
#   should follow the pattern key => rule_hash where the
#   key is the resource name for the rule and the hash
#   is key pairs of parameters and values for the firewall
#   resource.
# @param [Optional[Integer]] ssh_port
#   The port to open for SSH in the pre rules (if applied).
#   Default: 22
# @param [Optional[Integer]] puppet_port
#   The port to open for the Pupept Agent in the pre rules (if applied).
#   Default: 8140
#
# @example
#   include abide_linux::utils::firewall::iptables
class abide_linux::utils::firewall::iptables (
  Optional[Boolean] $merge_defaults = undef,
  Optional[Boolean] $purge_nftables = undef,
  Optional[Boolean] $purge_firewalld = undef,
  Optional[Boolean] $ipv6 = undef,
  Optional[Boolean] $apply_pre_rules = undef,
  Optional[Boolean] $apply_post_rules = undef,
  Optional[Hash] $rules = undef,
  Optional[Integer] $ssh_port = undef,
  Optional[Integer] $puppet_port = undef,
) {
  $_merge_defaults = undef_default($merge_defaults, true)
  $_purge_nftables = undef_default($purge_nftables, true)
  $_purge_firewalld = undef_default($purge_firewalld, true)
  $_ipv6 = undef_default($ipv6, true)
  $_apply_pre_rules = undef_default($apply_pre_rules, true)
  $_apply_post_rules = undef_default($apply_post_rules, true)
  $_ud_rules = undef_default($rules, {})
  $_ssh_port = undef_default($ssh_port, 22)
  $_puppet_port = undef_default($puppet_port, 8140)

  if $_ipv6 {
    $_d_rules = {
      '010 accept tcp IPv4 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'tcp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
      },
      '010 accept udp IPv4 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'udp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
      },
      '010 accept icmp IPv4 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'icmp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
      },
      '010 accept tcp IPv6 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'tcp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
        'provider' => 'ip6tables',
      },
      '010 accept udp IPv6 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'udp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
        'provider' => 'ip6tables',
      },
      '010 accept icmp IPv6 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'icmp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
        'provider' => 'ip6tables',
      },
      '011 accept tcp IPv4 input established' => {
        'chain' => 'INPUT',
        'proto' => 'tcp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
      },
      '011 accept udp IPv4 input established' => {
        'chain' => 'INPUT',
        'proto' => 'udp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
      },
      '011 accept icmp IPv4 input established' => {
        'chain' => 'INPUT',
        'proto' => 'icmp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
      },
      '011 accept tcp IPv6 input established' => {
        'chain' => 'INPUT',
        'proto' => 'tcp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
        'provider' => 'ip6tables',
      },
      '011 accept udp IPv6 input established' => {
        'chain' => 'INPUT',
        'proto' => 'udp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
        'provider' => 'ip6tables',
      },
      '011 accept icmp IPv6 input established' => {
        'chain' => 'INPUT',
        'proto' => 'icmp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
        'provider' => 'ip6tables',
      },
    }
  } else {
    $_d_rules = {
      '010 accept tcp IPv4 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'tcp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
      },
      '010 accept udp IPv4 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'udp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
      },
      '010 accept icmp IPv4 output new and established' => {
        'chain' => 'OUTPUT',
        'proto' => 'icmp',
        'state' => ['NEW', 'ESTABLISHED'],
        'action' => 'accept',
      },
      '011 accept tcp IPv4 input established' => {
        'chain' => 'INPUT',
        'proto' => 'tcp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
      },
      '011 accept udp IPv4 input established' => {
        'chain' => 'INPUT',
        'proto' => 'udp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
      },
      '011 accept icmp IPv4 input established' => {
        'chain' => 'INPUT',
        'proto' => 'icmp',
        'state' => 'ESTABLISHED',
        'action' => 'accept',
      },
    }
  }

  $_rules = $_merge_defaults ? {
    true => merge($_ud_rules, $_d_rules),
    default => $_ud_rules,
  }

  $_ip6ensure = $_ipv6 ? {
    true => 'running',
    default => undef,
  }

  class { 'firewall':
    ensure    => running,
    ensure_v6 => $_ip6ensure,
  }

  if $_purge_nftables {
    abide_linux::utils::packages::absenter { 'nftables':
      before  => Class['abide_linux::utils::firewall::iptables::pre'],
    }
  } else {
    service { 'nftables':
      ensure => stopped,
      enable => 'mask',
      before => Class['abide_linux::utils::firewall::iptables::pre'],
    }
  }

  if $_purge_firewalld {
    abide_linux::utils::packages::absenter { 'firewalld':
      before  => Class['abide_linux::utils::firewall::iptables::pre'],
    }
  } else {
    service { 'firewalld':
      ensure => stopped,
      enable => 'mask',
      before => Class['abide_linux::utils::firewall::iptables::pre'],
    }
  }

  Firewall {
    before  => Class['abide_linux::utils::firewall::iptables::post'],
    require => Class['abide_linux::utils::firewall::iptables::pre']
  }
  class { 'abide_linux::utils::firewall::iptables::pre':
    apply       => $_apply_pre_rules,
    ssh_port    => $_ssh_port,
    puppet_port => $_puppet_port,
  }
  class { 'abide_linux::utils::firewall::iptables::post':
    apply => $_apply_post_rules,
  }
  $_rules.each | String $key, Hash $val | {
    firewall { $key:
      * => $val,
    }
  }
}
