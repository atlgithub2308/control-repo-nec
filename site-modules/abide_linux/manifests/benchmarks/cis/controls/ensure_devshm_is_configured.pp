# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] noexec
# @option config [Boolean] nosuid
# @option config [Boolean] nodev
#
# @see abide_linux::utils::fstab_entry
class abide_linux::benchmarks::cis::controls::ensure_devshm_is_configured (
  Boolean $enforced = true,
  Hash $config = {}
) {
  abide_linux::utils::fstab_entry { '/dev/shm':
    ensure  => 'present',
    device  => 'tmpfs',
    fstype  => 'tmpfs',
    noexec  => dig($config, 'noexec'),
    nosuid  => dig($config, 'nosuid'),
    nodev   => dig($config, 'nodev'),
    options => dig($config, 'options'),
  }
}
