# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] sudoers_path
#
# @see abide_linux::utils::packages::linux::sudo::sudoers_default
class abide_linux::benchmarks::cis::controls::ensure_sudo_commands_use_pty (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    abide_linux::utils::packages::linux::sudo::sudoers_default { 'use_pty':
      sudoers_path => dig($config, 'sudoers_path'),
    }
  }
}
