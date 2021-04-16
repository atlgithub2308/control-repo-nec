# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::firewall::nftables
class abide_linux::utils::firewall::nftables (
  Optional[Boolean] $purge_iptables_services = undef,
  Optional[Boolean] $merge_defaults = undef,
  Optional[Boolean] $in_ssh = undef,
  Optional[Boolean] $in_icmp = undef,
  Optional[Boolean] $out_ntp = undef,
  Optional[Boolean] $out_dns = undef,
  Optional[Boolean] $out_http = undef,
  Optional[Boolean] $out_https = undef,
  Optional[Boolean] $out_icmp = undef,
  Optional[Boolean] $out_all = undef,
  Optional[Boolean] $in_out_conntrack = undef,
  Optional[Boolean] $fwd_conntrack = undef,
  Optional[Boolean] $nat = undef,
  Optional[Hash] $rules = undef,
  Optional[Hash] $sets = undef,
  Optional[String] $log_prefix = undef,
  Optional[Variant[Boolean[false], String]] $log_limit = undef,
  Optional[Variant[Boolean[false], Pattern[/icmp(v6|x)? type .+|tcp reset/]]] $reject_with = undef,
  Optional[Variant[Boolean[false], Enum['mask']]] $firewalld_enable = undef,
  Optional[Array[Pattern[/^(ip|ip6|inet)-[-a-zA-Z0-9_]+$/],1]] $noflush_tables = undef,
) {
  # Fail if they node OS can't support nftables
  if versioncmp($facts['kernelversion'], '3.13.0') == -1 {
    fail('nftables requires linux kernel >= 3.13')
  }
  $_purge_iptables_services = undef_default($purge_iptables_services, true)
  $_merge_defaults = undef_default($merge_defaults, true)
  $_in_ssh = undef_default($in_ssh, true)
  $_in_icmp = undef_default($in_icmp, true)
  $_out_ntp = undef_default($out_ntp, true)
  $_out_dns = undef_default($out_dns, true)
  $_out_http = undef_default($out_http, true)
  $_out_https = undef_default($out_https, true)
  $_out_icmp = undef_default($out_icmp, true)
  $_out_all = undef_default($out_all, false)
  $_in_out_conntrack = undef_default($in_out_conntrack, true)
  $_fwd_conntrack = undef_default($fwd_conntrack, false)
  $_nat = undef_default($nat, true)
  $_ud_rules = undef_default($rules, {})
  $_sets = undef_default($sets, {})
  $_log_prefix = undef_default($log_prefix, '[nftables] %<chain>s %<comment>s')
  $_log_limit = undef_default($log_limit, '3/minute burst 5 packets')
  $_reject_with = undef_default($reject_with, 'icmpx type port-unreachable')
  $_firewalld_enable = undef_default($firewalld_enable, 'mask')

  # Default rules so nftables doesn't lock us out of the system.
  # Opens port 22 and 8140, and makes allowances for established
  # inbound connections.
  # All of these rules use the default table inet-filter
  $_d_rules = {
    'input-filter_hook' => {
      'content' => 'type filter hook input priority 0; policy drop;',
    },
    'input-accept_lo' => {
      'content' => 'iif "lo" accept',
    },
    'input-ip_home_saddr' => {
      'content' => 'ip saddr 127.0.0.0/8 counter packets 0 bytes 0 drop',
    },
    'input-ip6_home_saddr' => {
      'content' => 'ip6 saddr ::1 counter packets 0 bytes 0 drop',
    },
    'input-tcp_state_established' => {
      'content' => 'ip protocol tcp ct state established accept',
    },
    'input-udp_state_established' => {
      'content' => 'ip protocol udp ct state established accept',
    },
    'input-icmp_state_established' => {
      'content' => 'ip protocol icmp ct state established accept',
    },
    'input-accept_ssh' => {
      'content' => 'tcp dport ssh accept',
    },
    'input-accept_puppet_tcp' => {
      'content' => 'tcp dport 8140 accept',
    },
    'input-accept_icmpv6' => {
      # lint:ignore:140chars
      'content' => 'icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-done, nd- router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, ind- neighbor-solicit, ind-neighbor-advert, mld2-listener-report } accept',
    },
    'input-accept_icmp' => {
      'content' => 'icmp type { destination-unreachable, router-advertisement, router- solicitation, time-exceeded, parameter-problem } accept',
      # lint:endignore
    },
    'input-accept_igmp' => {
      'content' => 'ip protocol igmp accept',
    },
    'forward-filter_hook' => {
      'content' => 'type filter hook output priority 0; policy drop;',
    },
    'output-filter_hook' => {
      'content' => 'type filter hook output priority 0; policy drop;',
    },
    'output-tcp_state_established' => {
      'content' => 'ip protocol tcp ct state established accept',
    },
    'output-udp_state_established' => {
      'content' => 'ip protocol udp ct state established accept',
    },
    'output-icmp_state_established' => {
      'content' => 'ip protocol icmp ct state established accept',
    },
  }
  $_rules = $_merge_defaults ? {
    true => merge($_ud_rules, $_d_rules),
    default => $_ud_rules,
  }
  if $_purge_iptables_services {
    abide_linux::utils::packages::absenter { 'nftables_iptables_services':
      pkg_name => 'iptables-services',
    }
  }
  # class { 'nftables':
  #   in_ssh           => $_in_ssh,
  #   in_icmp          => $_in_icmp,
  #   out_ntp          => $_out_ntp,
  #   out_dns          => $_out_dns,
  #   out_http         => $_out_http,
  #   out_https        => $_out_https,
  #   out_icmp         => $_out_icmp,
  #   out_all          => $_out_all,
  #   in_out_conntrack => $_in_out_conntrack,
  #   fwd_conntrack    => $_fwd_conntrack,
  #   nat              => $_nat,
  #   rules            => $_rules,
  #   log_prefix       => $_log_prefix,
  #   log_limit        => $_log_limit,
  #   reject_with      => $_reject_with,
  #   firewalld_enable => $_firewalld_enable,
  #   noflush_tables   => $noflush_tables,
  # }
}
