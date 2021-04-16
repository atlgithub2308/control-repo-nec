# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] enforce_sshd_config_perms
# @option config [Boolean] enforce_host_key_perms
# @option config [Enum[INFO, VERBOSE]] log_level
# @option config [Enum[yes, no]] x11_forwarding
# @option config [Integer] max_auth_tries
# @option config [Enum[yes, no]] ignore_rhosts
# @option config [Enum[yes, no]] host_based_authentication
# @option config [Enum[yes, no]] permit_root_login
# @option config [Enum[yes, no]] permit_empty_passwords
# @option config [Enum[yes, no]] permit_user_environment
# @option config [Array[String]] ciphers
# @option config [String] macs
# @option config [String] kex_algorithms
# @option config [Integer] client_alive_interval
# @option config [Integer] client_alive_count_max
# @option config [Integer] login_grace_time
# @option config [Stdlib::AbsolutePath] banner
# @option config [Enum[yes, no]] use_pam
# @option config [Enum[yes, no]] allow_tcp_forwarding
# @option config [String] max_startups
# @option config [Integer] max_sessions
# @option config [Stdlib::AbsolutePath] config_path
# @option config [String] config_comment
# @option config [Array[String]] allow_users
# @option config [Array[String]] allow_groups
# @option config [Array[String]] deny_users
# @option config [Array[String]] deny_groups
#
# @see abide_linux::utils::packages::linux::ssh
class abide_linux::benchmarks::cis::controls::ensure_permissions_on_etcsshsshd_config_are_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::packages::linux::ssh':
    enforce_sshd_config_perms => dig($config, 'enforce_sshd_config_perms'),
    enforce_host_key_perms    => dig($config, 'enforce_host_key_perms'),
    log_level                 => dig($config, 'log_level'),
    x11_forwarding            => dig($config, 'x11_forwarding'),
    max_auth_tries            => dig($config, 'max_auth_tries'),
    ignore_rhosts             => dig($config, 'ignore_rhosts'),
    host_based_authentication => dig($config, 'host_based_authentication'),
    permit_root_login         => dig($config, 'permit_root_login'),
    permit_empty_passwords    => dig($config, 'permit_empty_passwords'),
    permit_user_environment   => dig($config, 'permit_user_environment'),
    ciphers                   => dig($config, 'ciphers'),
    macs                      => dig($config, 'macs'),
    kex_algorithms            => dig($config, 'kex_algorithms'),
    client_alive_interval     => dig($config, 'client_alive_interval'),
    client_alive_count_max    => dig($config, 'client_alive_count_max'),
    login_grace_time          => dig($config, 'login_grace_time'),
    banner                    => dig($config, 'banner'),
    use_pam                   => dig($config, 'use_pam'),
    allow_tcp_forwarding      => dig($config, 'allow_tcp_forwarding'),
    max_startups              => dig($config, 'max_startups'),
    max_sessions              => dig($config, 'max_sessions'),
    config_path               => dig($config, 'config_path'),
    config_comment            => dig($config, 'config_comment'),
    allow_users               => dig($config, 'allow_users'),
    allow_groups              => dig($config, 'allow_groups'),
    deny_users                => dig($config, 'deny_users'),
    deny_groups               => dig($config, 'deny_groups'),
  }
}
