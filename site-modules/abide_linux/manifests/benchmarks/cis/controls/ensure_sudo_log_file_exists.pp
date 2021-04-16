# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [String] sudoers_path
# @option config [String] value
#
# @see abide_linux::utils::packages::linux::sudo::sudoers_default
class abide_linux::benchmarks::cis::controls::ensure_sudo_log_file_exists (
  Boolean $enforced = true,
  Hash $config = {},
) {
  $_value = dig($config, 'value') ? {
    undef => '/var/log/sudo.log',
    default => dig($config, 'value'),
  }
  if $enforced {
    abide_linux::utils::packages::linux::sudo::sudoers_default { 'logfile':
      sudoers_path => dig($config, 'sudoers_path'),
      value        => $_value,
    }
  }
}
