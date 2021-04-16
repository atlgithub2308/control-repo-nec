# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Enum[chrony, ntp]] preferred_package
# @option config [Boolean] manage_package
# @option config [Boolean] force_exclusivity
# @option config [Boolean] add_user_option
# @option config [String] ntp_user
# @option config [Array[String]] ntp_restricts
# @option config [Array[String]] timeservers
# @option config [String] sysconfig_options
# @option config [String] ntp_systemd_exec_start
#
# @see abide_linux::utils::timesync
class abide_linux::benchmarks::cis::controls::ensure_time_synchronization_is_in_use (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::timesync':
      preferred_package      => dig($config, 'preferred_package'),
      manage_package         => dig($config, 'manage_package'),
      force_exclusivity      => dig($config, 'force_exclusivity'),
      ntp_restricts          => dig($config, 'ntp_restricts'),
      timeservers            => dig($config, 'timeservers'),
      sysconfig_options      => dig($config, 'sysconfig_options'),
      ntp_systemd_exec_start => dig($config, 'ntp_systemd_exec_start'),
    }
  }
}
