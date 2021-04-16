# @api private
class abide_linux::utils::firewall::iptables::pre (
  Boolean $apply = true,
  Boolean $ipv6 = false,
  Integer $ssh_port = 22,
  Integer $puppet_port = 8140,
) {
  if $apply {
    Firewall {
      require => undef,
    }

    firewall { '000 accept all IPv4 to loopback':
      chain   => 'INPUT',
      proto   => 'all',
      iniface => 'lo',
      action  => 'accept',
    }
    -> firewall { '001 accept all IPv4 from loopback':
      chain    => 'OUTPUT',
      proto    => 'all',
      outiface => 'lo',
      action   => 'accept',
    }
    -> firewall { '002 drop all IPv4 input from 127.0.0.0/8':
      chain  => 'INPUT',
      source => '127.0.0.0/8',
      action => 'drop',
    }
    -> firewall { '003 accept new IPv4 inbound SSH connections':
      chain  => 'INPUT',
      proto  => 'tcp',
      dport  => $ssh_port,
      state  => 'NEW',
      action => 'accept',
    }
    -> firewall { '004 accept IPv4 Puppet agent traffic':
      proto  => 'tcp',
      dport  => $puppet_port,
      action => 'accept',
    }
    if $ipv6 {
      firewall { '000 accept all IPv6 to loopback':
        chain    => 'INPUT',
        proto    => 'all',
        iniface  => 'lo',
        action   => 'accept',
        provider => 'ip6tables',
        require  => Firewall['004 accept IPv4 Puppet agent traffic'],
      }
      -> firewall { '001 accept all IPv6 from loopback':
        chain    => 'OUTPUT',
        proto    => 'all',
        outiface => 'lo',
        action   => 'accept',
        provider => 'ip6tables',
      }
      -> firewall { '002 drop all IPv6 input from 127.0.0.0/8':
        chain    => 'INPUT',
        source   => '127.0.0.0/8',
        action   => 'drop',
        provider => 'ip6tables',
      }
      -> firewall { '003 accept new IPv6 inbound SSH connections':
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => $ssh_port,
        state    => 'NEW',
        action   => 'accept',
        provider => 'ip6tables',
      }
      -> firewall { '004 accept IPv6 Puppet agent traffic':
        proto    => 'tcp',
        dport    => $puppet_port,
        action   => 'accept',
        provider => 'ip6tables',
      }
    }
  }
}
