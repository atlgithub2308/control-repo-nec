# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Array[String]] proxy_packages
#
# @see abide_linux::utils::packages::absenter
class abide_linux::benchmarks::cis::controls::ensure_http_proxy_server_is_not_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    if dig($config, 'proxy_packages') {
      dig($config, 'proxy_packages').each | String $pkg | {
        abide_linux::utils::packages::absenter { $pkg: }
      }
    } else {
      abide_linux::utils::packages::absenter { 'squid': }
    }
  }
}
