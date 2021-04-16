# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] noexec
# @option config [Boolean] nodev
# @option config [Boolean] nosuid
# @option config [Array[String]] other_options
# 
# @see abide_linux::utils::services::systemd::tmp_mount
class abide_linux::benchmarks::cis::controls::ensure_tmp_is_configured (
  Boolean $enforced = true,
  Hash $config = {}
) {
  class { 'abide_linux::utils::services::systemd::tmp_mount':
    noexec        => dig($config, 'noexec'),
    nodev         => dig($config, 'nodev'),
    nosuid        => dig($config, 'nosuid'),
    other_options => dig($config, 'other_options'),
  }
}
