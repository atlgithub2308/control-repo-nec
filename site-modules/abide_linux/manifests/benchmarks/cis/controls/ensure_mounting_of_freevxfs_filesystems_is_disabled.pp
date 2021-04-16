# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::disable_fs_mounting
class abide_linux::benchmarks::cis::controls::ensure_mounting_of_freevxfs_filesystems_is_disabled (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    abide_linux::utils::disable_fs_mounting { 'freevxfs': }
  }
}
