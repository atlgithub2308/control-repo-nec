# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::file_permissions
class abide_linux::benchmarks::cis::controls::ensure_permissions_on_etcshadow_are_configured (
  Boolean $enforced = true,
  Hash $config = {}
) {
  abide_linux::utils::file_permissions { 'Abide - permissions for /etc/shadow':
    path  => '/etc/shadow',
    owner => 'root',
    group => 'root',
    mode  => '000',
  }
}