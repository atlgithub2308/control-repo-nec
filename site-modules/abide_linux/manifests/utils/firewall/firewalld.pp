# @summary Configures Firewalld on the host
#
# Provides a wrapper for puppet/firewalld that exposes most options.
# Additionally, will remove iptables-services and remove / mask
# nfltables base on parameter input.
#
# @param [Optional[Enum[present, installed, latest]]] ensure_package
#   Ensure for the firewalld package resource. Default: `installed`
# @param [Optional[Enum[present, installed, latest]]] ensure_iptables_package
#   Ensure for the iptables package resource. Default: `installed`
# @param [Optional[Boolean]] merge_defaults
#   If true, will merge user-specified parameters with class defaults, where
#   appropriate. This affects the $ports parameter because this class
#   specifies to open ports in the default settings, 22 and 8140, that are
#   required for SSH and Puppet agent communication, respectively. These
#   two port statements do not need to be redeclared if you have this
#   parameter set to true. Default: `true`
# @param [Optional[Boolean]] purge_iptables_services
#   When true, removes the package `iptables-services`. Default: `true`
# @param [Optional[Boolean]] purge_nftables
#   When true, removes the package `nftables`. If set to false, the
#   nftables service is stopped and masked instead.
# @param [Optional[String[1]]] default_zone
#   Sets the default firewalld zone to this zone. Default: `public`
# @param [Optional[Hash]] zones
#   A hash of firewalld zones to create. Default: `{}`
# lint:ignore:140chars
# @param [Optional[Hash]] ports
#   A hash of port configurations.
#   Default: `{ 'Open port tcp/22 on default zone (SSH)' => { 'ensure' => 'present', 'port' => 22, 'protocol' => 'tcp' }, 'Open port tcp/8140 on default zone (Puppet Agent)' => { 'ensure' => 'present', 'port' => 8140, 'protocol' => 'tcp' } }`
# lint:endignore
# @param [Optional[Hash]] services
#   A hash of services to create. Default: `{}`
# @param [Optional[Hash]] rich_rules
#   A hash of rich firewall rules to create. Default: `{}`
# @param [Optional[Hash]] custom_services
#   A hash of custom firewall services to create. This parameter is
#   deprecated in puppet/firewalld and should not be used, but is
#   exposed here for posterity. Default: `{}`
# @param [Optional[Hash]] ipsets
#   A hash of ipsets to create. Default: `{}`
# @param [Optional[Hash]] direct_rules
#   A hash of direct rules to create. Default: `{}`
# @param [Optional[Hash]] direct_chains
#   A hash of direct chains to create. Default: `{}`
# @param [Optional[Hash]] direct_passthroughs
#   A hash of direct passthroughs to create. Default: `{}`
# @param [Optional[Boolean]] purge_direct_rules
#   If true, will purge all direct rules not managed by this class.
#   Default: `false`
# @param [Optional[Boolean]] purge_direct_chains
#   If true, will purge all direct chains not managed by this class.
#   Default: `false`
# @param [Optional[Boolean]] purge_direct_passthroughs
#   If true, will purge all direct passthroughs not managed by this class.
#   Default: `false`
# @param [Optional[Boolean]] purge_unknown_ipsets
#   If true, will purge all ipsets not managed by this class.
#   Default: `false`
# @param [Optional[Enum[off, all, unicast, broadcast, multicast]]] log_denied
#   Set type of denied packets to log
# @param [Optional[Enum[yes, no]]] cleanup_on_exit
#   Whether or not to clean up firewalld config on exit or stop of firewalld
# @param [Optional[Enum[yes, no]]] zone_drifting
#   Whether or not to allow zone drifting
# @param [Optional[Integer]] minimal_mark
#   Marks up to this minimum are free for use
# @param [Optional[Enum[yes, no]]] lockdown
#   If yes, firewall changes will be limited to applications in the lockdown whitelist
# @param [Optional[Enum[yes, no]]] ipv6_rpfilter
#   If yes, enables reverse path filter test on IPv6 packets
# @param [Optional[String[1]]] default_service_zone
#   Sets the default zone for services
# @param [Optional[String[1]]] default_port_zone
#   Sets the default zone for ports
# @param [Optional[String[1]]] default_port_protocol
#   Sets the default protocol for ports
#
# @example
#   include abide_linux::utils::firewall::firewalld
class abide_linux::utils::firewall::firewalld (
  Optional[Enum['present', 'installed', 'latest']] $ensure_package = undef,
  Optional[Enum['present', 'installed', 'latest']] $ensure_iptables_package = undef,
  Optional[Boolean] $merge_defaults = undef,
  Optional[Boolean] $purge_iptables_services = undef,
  Optional[Boolean] $purge_nftables = undef,
  Optional[String[1]] $default_zone = undef,
  Optional[Hash] $zones = undef,
  Optional[Hash] $ports = undef,
  Optional[Hash] $services = undef,
  Optional[Hash] $rich_rules = undef,
  Optional[Hash] $custom_services = undef,
  Optional[Hash] $ipsets = undef,
  Optional[Hash] $direct_rules = undef,
  Optional[Hash] $direct_chains = undef,
  Optional[Hash] $direct_passthroughs = undef,
  Optional[Boolean] $purge_direct_rules = undef,
  Optional[Boolean] $purge_direct_chains = undef,
  Optional[Boolean] $purge_direct_passthroughs = undef,
  Optional[Boolean] $purge_unknown_ipsets = undef,
  Optional[Enum['off', 'all', 'unicast', 'broadcast', 'multicast']] $log_denied = undef,
  Optional[Enum['yes', 'no']] $cleanup_on_exit = undef,
  Optional[Enum['yes', 'no']] $zone_drifting = undef,
  Optional[Integer] $minimal_mark = undef,
  Optional[Enum['yes', 'no']] $lockdown = undef,
  Optional[Enum['yes', 'no']] $ipv6_rpfilter = undef,
  Optional[String[1]] $default_service_zone = undef,
  Optional[String[1]] $default_port_zone = undef,
  Optional[String[1]] $default_port_protocol = undef,
) {
  # These are considered necessary for our module to function
  $_d_ports = {
    'Open port tcp/22 on default zone (SSH)' => {
      'ensure' => 'present',
      'port'   => 22,
      'protocol' => 'tcp',
    },
    'Open port tcp/8140 on default zone (Puppet Agent)' => {
      'ensure' => 'present',
      'port'   => 8140,
      'protocol' => 'tcp',
    }
  }

  $_ensure_package = undef_default($ensure_package, 'installed')
  $_ensure_iptables_package = undef_default($ensure_iptables_package, 'installed')
  $_merge_defaults = undef_default($merge_defaults, true)
  $_purge_iptables_services = undef_default($purge_iptables_services, true)
  $_purge_nftables = undef_default($purge_nftables, true)
  $_default_zone = undef_default($default_zone, 'public')
  $_zones = undef_default($zones, {})
  $_ud_ports = undef_default($ports, {})
  $_services = undef_default($services, {})
  $_rich_rules = undef_default($rich_rules, {})
  $_custom_services = undef_default($custom_services, {})
  $_ipsets = undef_default($ipsets, {})
  $_direct_rules = undef_default($direct_rules, {})
  $_direct_chains = undef_default($direct_chains, {})
  $_direct_passthroughs = undef_default($direct_passthroughs, {})
  $_purge_direct_rules = undef_default($purge_direct_rules, false)
  $_purge_direct_chains = undef_default($purge_direct_chains, false)
  $_purge_direct_passthroughs = undef_default($purge_direct_passthroughs, false)
  $_purge_unknown_ipsets = undef_default($purge_unknown_ipsets, false)

  # Allows users who want to add ports to not have to reconfigure SSH and Puppet agent
  if $merge_defaults {
    $_ports = merge($_ud_ports, $_d_ports)
  } else {
    $_ports = $_ud_ports
  }

  if $_purge_iptables_services {
    abide_linux::utils::packages::absenter { 'firewalld_iptables_services':
      pkg_name => 'iptables-services',
    }
  }
  if $_purge_nftables {
    abide_linux::utils::packages::absenter { 'firewalld_nftables':
      pkg_name => 'nftables',
    }
  } else {
    service { 'abide_firewalld_mask_nftables':
      ensure => 'stopped',
      name   => 'nftables',
      enable => 'mask',
    }
  }
  class { 'firewalld':
    package_ensure            => $_ensure_package,
    package                   => 'firewalld',
    service_ensure            => 'running',
    service_enable            => true,
    zones                     => $_zones,
    ports                     => $_ports,
    services                  => $_services,
    rich_rules                => $_rich_rules,
    custom_services           => $_custom_services,
    ipsets                    => $_ipsets,
    direct_rules              => $_direct_rules,
    direct_chains             => $_direct_chains,
    direct_passthroughs       => $_direct_passthroughs,
    purge_direct_rules        => $_purge_direct_rules,
    purge_direct_chains       => $_purge_direct_chains,
    purge_direct_passthroughs => $_purge_direct_passthroughs,
    purge_unknown_ipsets      => $_purge_unknown_ipsets,
    log_denied                => $log_denied,
    cleanup_on_exit           => $cleanup_on_exit,
    zone_drifting             => $zone_drifting,
    minimal_mark              => $minimal_mark,
    lockdown                  => $lockdown,
    ipv6_rpfilter             => $ipv6_rpfilter,
    default_service_zone      => $default_service_zone,
    default_port_zone         => $default_port_zone,
    default_port_protocol     => $default_port_protocol,
  }
}
