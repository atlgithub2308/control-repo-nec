# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] keep_rsync
#
# @see abide_linux::utils::disable_service
# @see abide_linux::utils::packages::absenter
class abide_linux::benchmarks::cis::controls::ensure_rsync_is_not_installed_or_the_rsyncd_service_is_masked (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    if dig($config, 'keep_rsync') {
      abide_linux::utils::disable_service { 'rsyncd':
        mask => true,
      }
    } else {
      abide_linux::utils::packages::absenter { 'rsync': }
    }
  }
}
