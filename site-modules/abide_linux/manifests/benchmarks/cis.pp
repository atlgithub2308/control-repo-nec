# @summary Provides an OS-independent interface for the CIS benchmark profile
#
# @param [Optional[Enum[server, workstation]]] profile
#   Which benchmark profile you would like to enforce.
# @param [Optional[Enum['1', '2']]] level
#   Which CIS benchmark level to enforce.
# @param [Optional[Boolean]] include_dil
#   Whether or not to include the distribution-independent
#   linux benchmark as well as the OS-specific benchmark.
# @param [Optional[Array[String]]] only
#   Only enforce these rules. Takes precedence over $ignore.
# @param [Optional[Array[String]]] ignore
#   Ignore enforcement on these rules. Mutually exclusive with $only.
# @param [Optional[Array[String]]] preferred_exclusives
#   Some controls are mutually exclusive. This parameter contains names
#   of the preferred controls to enforce in the event that multiple,
#   mutually exclusive controls would be enforced. If there are many
#   controls that are mutually exclusive that fall under one section,
#   such as the firewall configs section, only the first control needs
#   to be specified as the other controls are considered children
#   and will automatically be excluded as well.
# @param [Optional[Hash]] control_configs
#   Override default configured values of a control. See docs for more info.
#
# @example
#      include abide::benchmarks::cis
class abide_linux::benchmarks::cis (
  Optional[Enum['server', 'workstation']] $profile = undef,
  Optional[Enum['1', '2']] $level = undef,
  Optional[Boolean] $include_dil = undef,
  Optional[Array[String]] $only = undef,
  Optional[Array[String]] $ignore = undef,
  Optional[Array[String]] $preferred_exclusives = undef,
  Optional[Hash] $control_configs = undef,
) {
  include stdlib

  $_profile = $profile ? {
    undef => 'server',
    default => $profile,
  }

  $_level = $level ? {
    undef => '1',
    default => $level,
  }

  $_include_dil = $include_dil ? {
    undef => true,
    default => false,
  }
  $_preferred_exclusives = $preferred_exclusives ? {
    undef => [
      'ensure_firewalld_is_installed',
    ],
    default => $preferred_exclusives,
  }

  $_dil = "abide_linux::benchmarks::cis_dil_benchmark::profile_level_${_level}__${_profile}"
  $_kernel = downcase($facts['kernel'])
  $_os = downcase($facts['os']['name'])
  $_majr = $facts['os']['release']['major']
  $_control_key = $_os ? {
    'redhat' => "cis_red_hat_enterprise_${_kernel}_${_majr}_benchmark",
    default  => "cis_${_os}_${_kernel}_${_majr}_benchmark",
  }
  $_profile_key = "profile_level_${_level}__${_profile}"
  $_lookup_key = "abide_linux::benchmarks::${_control_key}::${_profile_key}"
  $_controls_dir = "${module_directory($module_name)}/manifests/benchmarks/cis/controls"

  if $only !~ Undef {
    $_i_enforcing = $only
  } else {
    if $facts['kernel'] == 'Linux' {
      $_enforcing = $_include_dil ? {
        true => unique(lookup($_lookup_key) + lookup($_dil)),
        default => lookup($_lookup_key),
      }
      $_i_enforcing = $ignore ? {
        undef => $_enforcing,
        default => $_enforcing - $ignore,
      }
    }
  }
  $_conditionals = lookup("abide_linux::benchmarks::${_control_key}::conditional")
  $enforcing = process_conditionals($_i_enforcing, $_conditionals, $_preferred_exclusives)
  $enforcing.each | $item | {
    # Only declare classes we actually have
    if has_class($item, $_controls_dir) {
      $_config = dig($control_configs, $item)
      class { "abide_linux::benchmarks::cis::controls::${item}":
        enforced => true,
        config   => $_config,
      }
    }
  }
}
