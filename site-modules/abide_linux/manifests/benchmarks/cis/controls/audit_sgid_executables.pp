# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
class abide_linux::benchmarks::cis::controls::audit_sgid_executables (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included task audit_sgid_executables and confirm results.')
  }
}
