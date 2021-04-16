# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] keep_rpcbind
#
# @see abide_linux::utils::disable_service
# @see abide_linux::utils::packages::absenter
class abide_linux::benchmarks::cis::controls::ensure_rpcbind_is_not_installed_or_the__rpcbind_services_are_masked (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    if dig($config, 'keep_rpcbind') {
      abide_linux::utils::disable_service { 'rpcbind':
        mask => true,
      }
      abide_linux::utils::disable_service { 'rpcbind.socket':
        mask => true,
      }
    } else {
      abide_linux::utils::packages::absenter { 'rpcbind': }
    }
  }
}
