# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_password_creation_requirements_are_enforced
class abide_linux::benchmarks::cis::controls::ensure_password_reuse_is_limited (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_password_creation_requirements_are_enforced.')
  }
}
