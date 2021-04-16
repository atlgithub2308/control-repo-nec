# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] manage_etc_logrotate
# @option config [Boolean] merge_defaults
# @option config [Hash] etc_logrotate_settings
# @option config [Hash[String, Hash]] rules
#
# @see abide_linux::utils::packages::linux::logrotate
class abide_linux::benchmarks::cis::controls::ensure_logrotate_is_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::packages::linux::logrotate':
      manage_etc_logrotate   => dig($config, 'manage_etc_logrotate'),
      merge_defaults         => dig($config, 'manage_defaults'),
      etc_logrotate_settings => dig($config, 'etc_logrotate_settings'),
      rules                  => dig($config, 'rules'),
    }
  }
}
