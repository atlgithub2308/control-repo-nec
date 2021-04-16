# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] keep_nfsutils
#
# @see abide_linux::utils::disable_service
# @see abide_linux::utils::packages::absenter
class abide_linux::benchmarks::cis::controls::ensure_nfsutils_is_not_installed_or_the__nfsserver_service_is_masked (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    if dig($config, 'keep_nfsutils') {
      abide_linux::utils::disable_service { 'nfs-server':
        mask => true,
      }
    } else {
      abide_linux::utils::packages::absenter { 'nfs-utils': }
    }
  }
}
