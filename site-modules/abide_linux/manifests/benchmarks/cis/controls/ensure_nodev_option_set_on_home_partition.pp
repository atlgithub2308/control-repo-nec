# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::remount_fs
class abide_linux::benchmarks::cis::controls::ensure_nodev_option_set_on_home_partition (
  Boolean $enforced = true,
  Hash $config = {}
) {
  if $enforced {
    abide_linux::utils::remount_fs { '/home':
      options => ['nodev'],
    }
  }
}
