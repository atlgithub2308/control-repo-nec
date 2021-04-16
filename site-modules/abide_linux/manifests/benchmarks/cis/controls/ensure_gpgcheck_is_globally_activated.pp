# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] yum_conf
# @option config [Array[String]] repo_files
#
# @see abide_linux::utils::yum::enable_gpgcheck
class abide_linux::benchmarks::cis::controls::ensure_gpgcheck_is_globally_activated (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::yum::enable_gpgcheck':
      yum_conf   => dig($config, 'yum_conf'),
      repo_files => dig($config, 'repo_files'),
    }
  }
}
