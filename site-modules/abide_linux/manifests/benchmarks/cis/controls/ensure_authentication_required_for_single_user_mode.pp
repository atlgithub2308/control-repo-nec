# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide_linux::utils::services::systemd::secure_rescue_service
# @see abide_linux::utils::services::systemd::secure_emergency_service
class abide_linux::benchmarks::cis::controls::ensure_authentication_required_for_single_user_mode (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    include abide_linux::utils::services::systemd::secure_rescue_service
    include abide_linux::utils::services::systemd::secure_emergency_service
  }
}
