# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see tasks/redhat_subscription_manager
class abide_linux::benchmarks::cis::controls::ensure_red_hat_subscription_manager_connection_is_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    if $facts['abide_redhat_subscription_manager'] == 'unregistered' {
      notice('Please run the included Bolt task "redhat_subscription_manager" to register.')
    }
  }
}
