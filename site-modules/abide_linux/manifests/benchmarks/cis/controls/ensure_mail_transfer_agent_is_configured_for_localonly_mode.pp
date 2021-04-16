# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::local_only_mta
class abide_linux::benchmarks::cis::controls::ensure_mail_transfer_agent_is_configured_for_localonly_mode (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    include abide_linux::utils::local_only_mta
  }
}
